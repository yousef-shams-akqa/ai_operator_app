import 'package:ai_operator_app/core/ai/models/function_call_response.dart';
import 'package:ai_operator_app/core/ai/interfaces/ai_executable_action.dart';
import 'package:either_dart/either.dart';

abstract class AiActionHandler {
  final List<AiExecutableAction> actions;

  AiActionHandler({required this.actions});

  Future<Either<Error, String>> handle(FunctionCallResponse response);
}
