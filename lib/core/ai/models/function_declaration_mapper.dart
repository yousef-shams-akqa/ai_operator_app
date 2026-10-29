import 'package:ai_operator_app/core/ai/models/function_declaration.dart'
    as app;
import 'package:firebase_ai/firebase_ai.dart';

/// Maps app-level [app.FunctionDeclaration] to Gemini SDK types.
abstract final class FunctionDeclarationMapper {
  FunctionDeclarationMapper._();

  /// Maps a single declaration to Gemini [FunctionDeclaration].
  static FunctionDeclaration toGemini(app.FunctionDeclaration declaration) {
    final parameters = declaration.parameters.map(
      (key, type) => MapEntry(key, _schemaFromType(type)),
    );

    return FunctionDeclaration(
      declaration.name,
      declaration.description,
      parameters: parameters,
      optionalParameters: declaration.optionalParameters,
    );
  }

  static List<Tool> toolsFromDeclarations(
    List<app.FunctionDeclaration> declarations,
  ) {
    if (declarations.isEmpty) {
      return const [];
    }

    return [
      Tool.functionDeclarations(
        declarations.map(toGemini).toList(),
      ),
    ];
  }

  static Schema _schemaFromType(app.FunctionParameterType type) {
    switch (type) {
      case app.FunctionParameterType.string:
        return Schema.string();
      case app.FunctionParameterType.number:
        return Schema.number();
      case app.FunctionParameterType.integer:
        return Schema.integer();
      case app.FunctionParameterType.boolean:
        return Schema.boolean();
    }
  }
}
