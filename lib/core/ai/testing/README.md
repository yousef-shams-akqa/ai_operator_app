# Core AI tests

## Purpose

Keep a small offline suite for the `AIService` contract, shared `core/ai` logic
and navigation-context regressions. Provider payload details and factory wiring
checks are intentionally excluded.

## Entry Points

Run from the repository root:

```sh
flutter test --no-pub lib/core/ai/testing
flutter analyze --no-pub lib/core/ai
```

The explicit path is required because default Flutter test discovery uses
`test/`. The existing `flutter_test` dev dependency has a narrow import lint
exception because these tests live under `lib/`.

| Suite | Behavior covered |
| --- | --- |
| `ai_service_test.dart` | Tool execution, failed-action results, empty replies and loop limits; four shared scenarios run against each real implementation |
| `json_schema_function_definition_mapper_test.dart` | Required/optional arguments, enums, and zero-argument functions |
| `ai_provider_client_test.dart` | Object-response acceptance, non-object rejection, provider error detail and fallback |
| `app_router_context_test.dart` | Evaluated context after navigation, nested routes, shell routes and stateful shell branches |

## Flow

Each test calls a production public method and checks its result. Schema
fixtures live in the schema test. Client tests use a Dio interceptor to supply
response objects without a transport or network request. Router tests own and
dispose their `GoRouter` instances.

`ai_service_test.dart` calls the real implementations through `AIService`.
`support/ai_service_fixture.dart` supplies provider-shaped canned responses and
records the actual requests and action calls. The shared assertions check tool
arguments and the result/error payload sent back to the model. No `AIService`
implementation is mocked.

All fixtures and scripts are runtime-only test data owned by individual tests.
There are no persisted fixtures or cached state. Gemini uses the SDK's test
model factory with an in-memory client; its SDK serialization and parsing stay
active without Firebase initialization. The test-only SDK imports are isolated
in the fixture file.

## Common Changes

- Add tests for a concrete regression or an important parsing rule.
- Keep expected schemas literal rather than deriving them with the mapper
  under test.
- Keep provider SDK behavior and constructor/property checks out of this suite.
- Add common service behavior once in `ai_service_test.dart`; keep provider
  response shapes in the fixture. Verify the SDK test-factory imports after a
  Firebase AI upgrade.

## Testing

The suite covers the service contract, shared response/schema handling and the
router-context regression. The loop-limit scenario checks that execution stops
at `maxToolRounds`; Gemini reads a follow-up response to detect further calls.
Provider payload details, Firebase setup/authentication and live API integration
remain outside this suite. Client tests close Dio instances during teardown.
