import 'package:ai_operator_app/core/ai/models/function_definition.dart';

abstract class FunctionDefinitionMapper<T> {
  List<T> toolsFromDefinitions(List<FunctionDefinition> definitions);
}