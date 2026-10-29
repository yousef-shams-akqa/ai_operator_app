import 'function_declaration.dart';

/// Runtime configuration for an AI session: instructions and available tools.
class AIConfiguration {
  const AIConfiguration({
    required this.systemPrompt,
    this.functionDeclarations = const [],
  });

  final String systemPrompt;
  final List<FunctionDeclaration> functionDeclarations;

  AIConfiguration copyWith({
    String? systemPrompt,
    List<FunctionDeclaration>? functionDeclarations,
  }) {
    return AIConfiguration(
      systemPrompt: systemPrompt ?? this.systemPrompt,
      functionDeclarations: functionDeclarations ?? this.functionDeclarations,
    );
  }
}
