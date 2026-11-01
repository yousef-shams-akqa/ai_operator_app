import 'package:ai_operator_app/core/ai/constants/ai_constants.dart';
import 'package:ai_operator_app/core/ai/models/ai_configuration.dart';
import 'package:ai_operator_app/core/ai/models/chat_message.dart';
import 'package:ai_operator_app/core/ai/models/function_call_response.dart';
import 'package:ai_operator_app/core/ai/interfaces/ai_action_handler.dart';
import 'package:ai_operator_app/core/ai/service/ai_service.dart';
import 'package:ai_operator_app/core/ai/service/json_schema_function_definition_mapper.dart';
import 'package:ai_operator_app/core/domain/failures/ai_provider_failure.dart';
import 'package:ai_operator_app/shared/constants/app_constants.dart';
import 'package:firebase_ai/firebase_ai.dart';

class GeminiAIService implements AIService {
  final GenerativeModel model;
  @override
  final String modelName;
  @override
  final AIConfiguration configuration;
  @override
  final AiActionHandler actionHandler;

  GeminiAIService._(this.model, this.modelName, this.configuration, this.actionHandler);

  static GeminiAIService? instance;
  static final _functionDefinitionMapper = JsonSchemaFunctionDefinitionMapper();
  static GeminiAIService initialize({
    String modelName = AppConstants.geminiModel,
    required AIConfiguration configuration,
    required AiActionHandler actionHandler,
  }) {
    final definitions = _functionDefinitionMapper.toolsFromDefinitions(configuration.functionDefinitions);
    final model = FirebaseAI.googleAI().generativeModel(
      model: modelName,
      systemInstruction: Content.text(configuration.systemPrompt),
      tools: definitions.isEmpty ? null
          : [Tool.functionDeclarations(definitions.map(_JsonFunctionDeclaration.new).toList())],
    );

    return instance ??= GeminiAIService._(model, modelName, configuration, actionHandler);
  }

  @override
  Future<String> send(String requestForAI, List<ChatMessage> chatHistory, {String? appContext}) async {
    try {
      final chatHistoryContent = chatHistory.map(chatMessageToModelContent).toList();
      final aiModelChat = model.startChat(history: chatHistoryContent);
      final textMessageForAI = requestForAI + (appContext ?? '');
      var aiResponse = await aiModelChat.sendMessage(Content.text(textMessageForAI));

      for (var round = 0; aiResponse.functionCalls.isNotEmpty; round++) {
        if (round >= AIConstants.maxToolRounds) {
          throw AIProviderTooManyCallsFailure();
        }
        final functionResponseParts = <FunctionResponse>[];

        for (final call in aiResponse.functionCalls) {
          final functionCallResponse = FunctionCallResponse(call.name, call.args);
          final actionResult = await actionHandler.handle(functionCallResponse);
          final actionResultPayload = actionResult.fold(
            (error) => {'error': error.toString()},
            (value) => {'result': value},
          );

          functionResponseParts.add(
            FunctionResponse(call.name, actionResultPayload, id: call.id),
          );
        }

        aiResponse = await aiModelChat.sendMessage(Content.functionResponses(functionResponseParts));
      }

      return aiResponse.text ?? (throw AIProviderEmptyResponseFailure());
    } on FirebaseAIException catch (error) {
      throw AIProviderRequestFailure(message: error.message);
    } on FirebaseAISdkException {
      throw AIProviderInvalidResponseFailure();
    }
  }

  Content chatMessageToModelContent(ChatMessage chatMessage) {
    return switch (chatMessage.type) {
      ChatMessageType.user => Content.text(chatMessage.message),
      ChatMessageType.model => Content.model([TextPart(chatMessage.message)]),
    };
  }
}

/// Sends a tool from [JsonSchemaFunctionDefinitionMapper] to Gemini unchanged.
///
/// The SDK only builds declarations from its own typed schemas, so this
/// replaces the generated JSON with the shared one. Only `Tool.toJson` reads
/// a declaration, so overriding `toJson` is enough.
class _JsonFunctionDeclaration extends FunctionDeclaration {
  final Map<String, dynamic> _definition;

  static const _nameKey = 'name';
  static const _descriptionKey = 'description';
  static const _parametersKey = 'parameters';
  static const _parametersJsonSchemaKey = 'parametersJsonSchema';

  _JsonFunctionDeclaration(this._definition) : super(
        _definition[_nameKey] as String,
        _definition[_descriptionKey] as String,
        parameters: const {},
      );

  @override
  Map<String, Object?> toJson() => {
    _nameKey: _definition[_nameKey],
    _descriptionKey: _definition[_descriptionKey],
    _parametersJsonSchemaKey: _definition[_parametersKey],
  };
}
