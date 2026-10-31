import 'package:ai_operator_app/core/ai/models/ai_configuration.dart';
import 'package:ai_operator_app/core/ai/models/chat_message.dart';
import 'package:ai_operator_app/core/ai/models/function_call_response.dart';
import 'package:ai_operator_app/core/ai/interfaces/ai_action_handler.dart';
import 'package:ai_operator_app/core/ai/service/ai_service.dart';
import 'package:ai_operator_app/core/ai/service/gemini/gemini_function_definition_mapper.dart';
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
  static GeminiAIService initialize({
    String modelName = AppConstants.geminiModel,
    required AIConfiguration configuration,
    required AiActionHandler actionHandler,
  }) {
    final tools = GeminiFunctionDefinitionMapper().toolsFromDefinitions(configuration.functionDefinitions);
    final model = FirebaseAI.googleAI().generativeModel(
      model: modelName,
      systemInstruction: Content.text(configuration.systemPrompt),
      tools: tools.isEmpty ? null : tools,
    );

    return instance ??= GeminiAIService._(model, modelName, configuration, actionHandler);
  }

  @override
  Future<String> send(String requestForAI, List<ChatMessage> chatHistory, {String? appContext}) async {
    final chatHistoryContent = chatHistory.map(chatMessageToModelContent).toList();
    final aiModelChat = model.startChat(history: chatHistoryContent);
    final textMessageForAI = requestForAI + (appContext ?? '');
    var aiResponse = await aiModelChat.sendMessage(Content.text(textMessageForAI));

    while (aiResponse.functionCalls.isNotEmpty) {
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

    return aiResponse.text ?? '';
  }

  Content chatMessageToModelContent(ChatMessage chatMessage) {
    return switch (chatMessage.type) {
      ChatMessageType.user => Content.text(chatMessage.message),
      ChatMessageType.model => Content.model([TextPart(chatMessage.message)]),
    };
  }
}
