
import 'package:ai_operator_app/core/ai/constants/ai_constants.dart';

import 'function_definition.dart';

/// Runtime configuration for an AI session: instructions and available tools.
class AIConfiguration {
  const AIConfiguration({
    this.systemPrompt = AIConstants.systemPrompt,
    this.functionDefinitions = const [],
  });

  final String systemPrompt;
  final List<FunctionDefinition> functionDefinitions;

  AIConfiguration copyWith({
    String? systemPrompt,
    List<FunctionDefinition>? functionDefinitions,
  }) {
    return AIConfiguration(
      systemPrompt: systemPrompt ?? this.systemPrompt,
      functionDefinitions: functionDefinitions ?? this.functionDefinitions,
    );
  }
}
