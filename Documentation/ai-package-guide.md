# Turn `core/ai` into a Flutter package

A package is reusable code with its own `pubspec.yaml`, dependencies, and tests.
Your app imports it just like it imports `dio`.

**Start with one package containing all three AI providers.** You can keep it
inside this repository; a separate Git repository is optional.

## 1. Create the package

From the app's root folder:

```bash
flutter create --template=package packages/operator_ai
```

`operator_ai` is an example name. Choose an available name on
[pub.dev](https://pub.dev/) before publishing and use it throughout these steps.
Use the regular package template: your code can depend on Firebase without
implementing a native plugin itself. [Flutter package guide](https://docs.flutter.dev/packages-and-plugins/developing-packages).

The important folders will look like this:

```text
packages/operator_ai/
  pubspec.yaml              # Name, version, dependencies
  lib/operator_ai.dart      # What other apps can import
  lib/src/                  # Implementation files
  test/                     # Package tests
```

`lib/src` is internal by convention. Export the supported API through
`lib/operator_ai.dart`. [Dart package layout](https://dart.dev/tools/pub/create-packages).

## 2. Separate reusable code from app code

Your existing `AIService` + factory + action-handler interface is already a good
boundary. Preserve that pattern during the move.

| Move into the package | Keep in this app |
| --- | --- |
| `core/ai/service/`, including all providers | `helpers/app_router_context.dart`: it knows your router |
| `core/ai/models/` and `interfaces/` | `core/action_handler/ai_action_handler_impl.dart`: it runs your app's actions |
| `helpers/json_schema_function_definition_mapper.dart` | `shared/ai/ai_functions_definitions_list.dart`: it describes those actions |
| `core/domain/failures/ai_provider_failure.dart` | Screens, view models, use cases, Firebase setup, and API-key storage |

Keep the moved code's subfolders under `lib/src/`; put the failure file under
`lib/src/failures/`. Move `core/ai/testing/` into the package's `test/` folder,
including its support files.

Also split `AIConstants`: keep the tool-round limit in the package, but move
the app-specific system prompt into an app-owned constant. Pass it through
`AIConfiguration.systemPrompt`; give the package a generic default prompt.

The app continues to own configuration, available actions, and chat history.
The package owns provider requests, response parsing, tool-call loops, and
provider failures. This extraction needs no new state models or caching.

## 3. Fix dependencies and imports

In the **package's** `pubspec.yaml`, use these dependencies, matching the app's
current constraints:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.11.1
  firebase_ai: ^5.1.0
  either_dart: ^1.0.0
```

Keep the generated SDK constraints and development dependencies initially.
`go_router` stays with the app. Keep any dependencies the app still imports
directly, including `firebase_core` for initialization.

Inside moved files, replace imports beginning with
`package:ai_operator_app/core/ai/` with relative imports between the moved files.
Update the failure imports too. **The package must never import the app.**

Replace the generated contents of `lib/operator_ai.dart` with:

```dart
export 'src/service/ai_service.dart';
export 'src/service/ai_service_factory.dart';
export 'src/models/ai_provider.dart';
export 'src/models/ai_configuration.dart';
export 'src/models/chat_message.dart';
export 'src/models/function_definition.dart';
export 'src/models/function_call_response.dart';
export 'src/interfaces/ai_action_handler.dart';
export 'src/interfaces/ai_executable_action.dart';
export 'src/failures/ai_provider_failure.dart';
```

Keep the HTTP client and schema mapper internal. Package tests can import their
`package:operator_ai/src/...` paths.

## 4. Connect the app locally

Add this under `dependencies` in the **app's** `pubspec.yaml`:

```yaml
  operator_ai:
    path: packages/operator_ai
```

Run `flutter pub get` in the app. Replace app imports of moved types with:

```dart
import 'package:operator_ai/operator_ai.dart';
```

Keep constructing the service in `AppInitializer.initializeAI()` and passing
your configuration and `AiActionHandlerImpl`. Move `AppRouterContext` to
`core/navigation/` and update its app imports. Firebase initialization and App
Check stay in the app, before creating the Gemini service.

Once the app uses the package, remove the original copies of the moved files.
A local path dependency works before publishing. [Local package dependencies](https://docs.flutter.dev/packages-and-plugins/using-packages#dependencies-on-unpublished-packages).

## 5. Check it works

Replace the generated sample test with your moved tests and fix their imports.
From `packages/operator_ai`, run:

```bash
flutter pub get
dart format lib test
flutter analyze
flutter test
```

Then run `flutter analyze` and launch the app from the app root. Try an AI reply
and an action call. Add focused tests for provider failures, malformed responses,
and the tool-round limit. Preserve existing failure behavior during extraction;
keep UI error handling behind the app's use case.

## 6. Publish to pub.dev

Prepare these files in the **package folder**:

- `pubspec.yaml`: set a description and initial `version: 0.1.0`; add your real
  repository URL if available. Remove `publish_to: none` here if present;
  keep it in the app's pubspec. [Pubspec fields](https://dart.dev/tools/pub/pubspec).
- `README.md`: show installation, a small usage example, and Firebase setup
  requirements for Gemini.
- `CHANGELOG.md`: describe the first release.
- `LICENSE`: fill in the license text; the generated placeholder is insufficient.

Publishing requires a Google account and hosted/SDK dependencies rather than
local or Git dependencies. The app's local dependency is fine because the app
isn't being published. Review the upload for credentials and app-specific files;
published versions generally remain available. [Publishing requirements](https://dart.dev/tools/pub/publishing).

From `packages/operator_ai`, validate without uploading:

```bash
flutter pub publish --dry-run
```

Resolve the reported issues, review the file list, and commit your package
files to Git. When ready:

```bash
flutter pub publish
```

Follow the sign-in instructions and confirm the upload. The dry run only
validates; the second command publishes publicly. [Publish command](https://dart.dev/tools/pub/cmd/pub-lish).

After publication, replace the app's path dependency with:

```yaml
  operator_ai: ^0.1.0
```

Run `flutter pub get` again. For later releases, update the version and
changelog, repeat the checks, and publish the new version.
