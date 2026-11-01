# Integrating Gemma On Device in Flutter

## Purpose

This guide shows how to add a local Gemma chat model to a Flutter app with
`flutter_edge_ai` and the LiteRT-LM engine. The model runs on the device after
its initial download. The examples use Gemma 4 E2B because it supports the
function calls used by this app's agent.

## 1. Check SDK and model compatibility

The current `flutter_edge_ai` release on pub.dev requires Dart 3.12 or later.
This repository currently uses Flutter 3.38.10 / Dart 3.10.9 and declares
`sdk: ^3.10.9` in `pubspec.yaml`; upgrade Flutter to a release with Dart 3.12+
and raise the Dart constraint before adding the package.

Gemma 4 E2B's generic LiteRT-LM file is about 2.59 GB. It supports function
calling, which the agent needs for navigation and settings actions. Gemma 3 1B
is smaller, but the package docs list it as text-only, without function calling.
Check model size, license, supported devices, and model capabilities before
choosing another build. See the [model registry](https://flutteredge.ai/docs/registry).

## 2. Add the packages

Use the core package plus the engine that reads `.litertlm` model files:

```sh
flutter pub add flutter_edge_ai flutter_edge_ai_litertlm
```

The core package has no inference engine by itself. If the app uses other
Flutter Edge AI packages, keep their versions compatible and upgrade them
together. The project uses a Dart SDK constraint in `pubspec.yaml`; Flutter
must be upgraded before this command can resolve the current package release.

## 3. Complete native platform setup

### Android

LiteRT-LM requires Android API 30 or later and the `arm64-v8a` architecture.
Add the download permission to the main manifest so release builds can install
the model:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

In `android/app/build.gradle.kts`, set the minimum SDK and limit native builds
to the supported ABI:

```kotlin
defaultConfig {
    minSdk = 30
    ndk {
        abiFilters += listOf("arm64-v8a")
    }
}
```

An x86_64 Android emulator cannot load this LiteRT-LM engine. Use an arm64
emulator or a physical arm64 device.

### iOS

LiteRT-LM supports an iOS deployment target of 15.0. If the app uses CocoaPods,
set static linking in `ios/Podfile`:

```ruby
platform :ios, '15.0'

target 'Runner' do
  use_frameworks! :linkage => :static
  # Keep the existing Flutter pod setup here.
end
```

Enable file sharing in `ios/Runner/Info.plist`:

```xml
<key>UIFileSharingEnabled</key>
<true/>
```

For large models, the package docs recommend memory entitlements in the Runner
entitlements file. Check the current [iOS installation instructions](https://flutteredge.ai/docs/installation)
for the exact keys and any setup changes before release.

## 4. Register the engine once at startup

Add initialization to the existing app startup after
`WidgetsFlutterBinding.ensureInitialized()`. Do not initialize the engine from
a page's `build` method.

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_edge_ai_litertlm/flutter_edge_ai_litertlm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterEdgeAi.initialize(
    inferenceEngines: const [LiteRtLmEngine()],
  );

  runApp(const MyApp());
}
```

In an app that already has an initializer, add `FlutterEdgeAi.initialize` there
and keep existing setup such as Firebase and preferences initialization.

## 5. Download the model once

Offer model download during onboarding or from a settings screen. Show progress
and handle download errors; avoid blocking every app launch on a multi-gigabyte
download. Installed models persist across app restarts.

This example downloads a revision-pinned Gemma 4 E2B model from the public
LiteRT Community repository:

```dart
const gemma4E2bUrl =
    'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/'
    'resolve/b3ca0d2f076785a8f4b2219ddbd2bdb99954eae1/'
    'gemma-4-E2B-it.litertlm';

Future<void> installGemma4({required void Function(int) onProgress}) async {
  await FlutterEdgeAi.installModel(
    modelType: ModelType.gemma4,
    fileType: ModelFileType.litertlm,
  )
      .fromNetwork(gemma4E2bUrl)
      .withProgress(onProgress)
      .install();
}
```

The `fileType` selects the engine, so keep `ModelFileType.litertlm` for this
model. The URL points to a specific revision; check the registry for updated
builds. Gemma 4 E2B is listed with an Apache 2.0 license. Other models may be
gated and require Hugging Face authentication; do not commit or ship a reusable
private token in the app.

## 6. Open a chat and generate a reply

Load the active model and create one chat for the conversation. Reusing the
chat retains its conversation history. `maxTokens` is the model context size;
`maxOutputTokens` limits the reply length.

```dart
class GemmaChatService {
  InferenceModel? _model;
  InferenceChat? _chat;

  Future<void> open({String? systemPrompt}) async {
    final model = await FlutterEdgeAi.getActiveModel(maxTokens: 2048);
    _model = model;
    _chat = await model.createChat(
      systemInstruction: systemPrompt,
      maxOutputTokens: 256,
    );
  }

  Future<String> sendMessage(String prompt) async {
    final chat = _chat;
    if (chat == null) throw StateError('Call open() before sending a message.');

    await chat.addQueryChunk(
      Message.text(text: prompt, isUser: true),
    );

    final answer = StringBuffer();
    await for (final response in chat.generateChatResponseAsync()) {
      if (response is TextResponse) answer.write(response.token);
    }
    return answer.toString();
  }

  Future<void> close() async {
    await _chat?.close();
    await _model?.close();
    _chat = null;
    _model = null;
  }
}
```

Keep model and chat ownership in an AI service or repository, not in a screen
widget. Close the model when that owner is disposed. Catch the package's
`NoActiveModelError` and show an install or retry state if the model has not
been installed yet.

## 7. Add function calling when the app needs actions

Declare the functions the model may request as JSON-schema `Tool`s. Enable
function calling when creating the chat. The package's tool loop calls your
handler, returns its result to the model, and continues until the model gives a
final answer.

```dart
const tools = [
  Tool(
    name: 'setDarkMode',
    description: 'Turn dark mode on or off.',
    parameters: {
      'type': 'object',
      'properties': {
        'enabled': {
          'type': 'boolean',
          'description': 'Whether dark mode should be enabled.',
        },
      },
      'required': ['enabled'],
    },
  ),
];

_chat = await model.createChat(
  systemInstruction: systemPrompt,
  tools: tools,
  supportsFunctionCalls: true,
  maxOutputTokens: 256,
);
```

For the agent, use this tool-enabled `createChat` in place of the basic chat
creation in `GemmaChatService.open()`.

For each user turn, use the tool-aware stream:

```dart
final chat = _chat!;
await chat.addQueryChunk(
  Message.text(text: prompt, isUser: true),
);

final answer = StringBuffer();
await for (final response in chat.generateChatResponseWithTools(
  onToolCall: (call) async {
    // Adapt the package call to this app's action-handler input type.
    final result = await actionHandler.handle(
      app.FunctionCallResponse(call.name, call.args),
    );
    return result.fold(
      (failure) => {'error': failure.toString()},
      (value) => {'result': value},
    );
  },
)) {
  if (response is TextResponse) answer.write(response.token);
}
```

Import the app's function-call model with an alias to distinguish it from the
package's `FunctionCallResponse`:

```dart
import 'package:ai_operator_app/core/ai/models/function_call_response.dart' as app;
```

Map the current app-level `FunctionDefinition`s to `Tool`s; the tool name above
matches this app's `setDarkMode` action. Keep argument validation and the
allow-list in `AiActionHandlerImpl`. Gemma 4 function calling requires a
`.litertlm` model.

## 8. Connect it to the app's AI boundary

This project already has an `AIService` interface and a `SendAiRequestUsecase`.
Implement a local service that satisfies the same interface, then select that
service in the app's dependency setup. Today `AppInitializer.initializeAI()`
builds the service with `AIServiceFactory` (Gemini) and `lib/main.dart` injects
`AppInitializer.aiService`; the chat page does not need to know which provider
generated the response.

The current `ChatMessage` stores only user and assistant text. If the local
service creates a fresh chat for every request, map and restore history
explicitly. To preserve tool-call turns, keep Flutter Edge AI's full history,
including tool calls and tool results, or reuse the same chat object for the
conversation. The package can stream tokens; the current `AIService` returns a
`Future<String>`, so accumulating tokens into a string preserves the existing
UI contract. Change the contract only if the UI should render each token as it
arrives. Pass `AIConfiguration.systemPrompt` as `systemInstruction` and include
the current app context in the prompt or a separate message, so local replies
receive the same instructions and route context as Gemini replies.

## 9. Verify the integration

- Install on a physical arm64 Android or iOS device and confirm progress reaches
  completion.
- Close and reopen the app; confirm the installed model remains available.
- Turn on airplane mode after installation and send a prompt.
- Try the agent's existing navigation and settings actions with the tool loop.
- Check download failure, cancellation, insufficient storage, and missing-model
  states.
- Confirm unsupported Android APIs and ABIs are excluded from release builds.

## References

- [Flutter Edge AI on pub.dev](https://pub.dev/packages/flutter_edge_ai)
- [Installation and platform setup](https://flutteredge.ai/docs/installation)
- [Getting started](https://flutteredge.ai/docs/getting-started)
- [Function calling](https://flutteredge.ai/docs/function-calling)
- [Model registry](https://flutteredge.ai/docs/registry)
- [Gemma 4 E2B LiteRT model file](https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/blob/b3ca0d2f076785a8f4b2219ddbd2bdb99954eae1/gemma-4-E2B-it.litertlm)
