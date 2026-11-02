# Core AI integration notes

## Purpose

Connect the app to the `flutter_ai_operator` package. Provider implementations
live in `packages/flutter_ai_operator`. See the
[provider architecture](../../../documentation/features/ai-providers.md) for
the shared contract and failure types.

For a beginner walkthrough of extracting this code and publishing it, see
[the Flutter package guide](../../../Documentation/ai-package-guide.md).

## Entry Points

- `AIServiceFactory.create()` constructs the selected provider for normal use.
- `AIService.send(messages)` receives the full ordered
  conversation, including the current user message as its final element.
- `GeminiAIService` also accepts an optional SDK `GenerativeModel` so callers
  can supply a model with an offline transport.
- `AIConfiguration.contextSources` in `AppInitializer.initializeAI()` lists the
  live app state added to every request. It holds
  `GoRouterContextSource(appRouter)`, which reports the current stack and routes.

## Flow

Without an injected model, Gemini builds its model from `modelName` and
`configuration` through Firebase AI. With an injected model, the caller owns
its setup and must match those settings, including the system prompt and tool
definitions; the service does not reconfigure it. Each `send()` validates and
snapshots the supplied messages. Gemini starts a fresh SDK chat with all but
the final message, then sends that final user message as the prompt. The
snapshot receives context; stored messages stay unchanged. Empty input, a final
model message, or blank final user text produces `AIProviderInvalidInputFailure`
before contacting a provider. Configuration and messages are runtime-only;
the package adds no persistence or cache fallback.

`SendAiRequestUsecase` forwards the complete message list and preserves provider
failures in its explicit result. `AgentViewmodel` owns chat state, pending
request identity, success appends, and failure rollback. Late results are
ignored after clearing or closing, and overlapping sends are ignored.

The package reads every context source inside each `send()`, so the model sees
the current navigation stack without the view model or use case passing it.
`GoRouterContextSource` reads the same `appRouter` the app navigates with; the
route tree is fixed when the router is created and only the stack changes. If a
source throws, `send()` fails with `AIProviderContextFailure` and sends nothing.
The context is read once per request, so it can be out of date for the later
steps of a request in which the model navigates.

## Common Changes

- Keep model injection optional so factory-created services retain their
  existing Firebase setup.
- Keep navigation context derived from the router rather than storing a second
  copy of navigation state. Add other live state by implementing
  `AppContextSource` and listing it in `contextSources`; do not build context in
  view models.
- Pass the complete conversation once. Keep validation and request copying in
  the package, and keep chat storage and presentation state in the app.

## Testing

Run `flutter test --no-pub` from `packages/flutter_ai_operator` for provider
contract tests. Run the same command from the app root for application tests,
including `test/modules/agent/agent_viewmodel_test.dart`. The package's
[README](../../../packages/flutter_ai_operator/README.md) documents the public API.
