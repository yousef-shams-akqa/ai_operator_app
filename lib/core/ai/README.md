# Core AI integration notes

## Purpose

Keep provider integration and navigation context within `core/ai`. See the
[provider architecture](../../../documentation/features/ai-providers.md) for
the shared contract and failure types.

## Entry Points

- `AIServiceFactory.create()` constructs the selected provider for normal use.
- `GeminiAIService` also accepts an optional SDK `GenerativeModel` so callers
  can supply a model with an offline transport.
- `AppRouterContext.getRouterContext()` produces navigation context for a request.

## Flow

Without an injected model, Gemini builds its model from `modelName` and
`configuration` through Firebase AI. With an injected model, the caller owns
its setup and must match those settings, including the system prompt and tool
definitions; the service does not reconfigure it. Each `send()` still starts a
fresh chat with the supplied history. Model configuration is runtime-only and
is not persisted here. Failure mapping and caching behavior are unchanged.

Router context is derived from the supplied `GoRouter`. The context string
calls `currentStack()` and `routeTree()` to include their evaluated values.

## Common Changes

- Keep model injection optional so factory-created services retain their
  existing Firebase setup.
- Keep navigation context derived from the router rather than storing a second
  copy of navigation state.

## Testing

Run scoped static analysis with `flutter analyze --no-pub lib/core/ai`.
Focused regression tests are planned under `lib/core/ai/testing`; they have not
been added yet. Cover injected Gemini models with an offline SDK transport and
assert router context contains evaluated paths instead of method references.
