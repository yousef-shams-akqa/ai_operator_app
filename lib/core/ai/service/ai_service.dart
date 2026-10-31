
import 'package:ai_operator_app/core/ai/models/ai_configuration.dart';
import 'package:ai_operator_app/core/ai/interfaces/ai_action_handler.dart';

/// Abstract class for AI services.
/// [T] is the type of the tools used by the AI service.
abstract class AIService {
  final String modelName;
  final AIConfiguration configuration;
  final AiActionHandler actionHandler;
  
  AIService({required this.modelName, required this.configuration, required this.actionHandler});

  Future<String> send(String requestForAI, {String? appState});
}