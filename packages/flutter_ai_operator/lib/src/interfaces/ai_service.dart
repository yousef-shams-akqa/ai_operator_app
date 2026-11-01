
import '../models/ai_configuration.dart';
import 'ai_action_handler.dart';
import '../models/chat_message.dart';

/// One AI provider (Gemini, OpenAI, or Claude) behind a single contract.
///
/// Create instances with `AIServiceFactory`. The service holds no
/// conversation between calls; the caller passes the history every time.
abstract class AIService {
  final String modelName;
  final AIConfiguration configuration;
  final AiActionHandler actionHandler;
  
  AIService({required this.modelName, required this.configuration, required this.actionHandler});

  /// Sends [requestForAI] and returns the model's final text reply.
  ///
  /// Runs any functions the model asks for through [actionHandler] and keeps
  /// going until the model answers with text. [appContext] is appended to the
  /// request text (for example, the current screen and routes).
  ///
  /// Throws an `AIProviderFailure` subclass when the provider fails, answers
  /// with something unusable, or asks for tools too many times in a row.
  Future<String> send(String requestForAI, List<ChatMessage> chatHistory, {String? appContext});
}
