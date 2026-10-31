
import 'package:ai_operator_app/core/ai/service/ai_service.dart';
import 'package:either_dart/either.dart';

class SendAiRequestUsecase {
  final AIService aiService;

  SendAiRequestUsecase({required this.aiService});

  Future<Either<Error, String>> call(String message, {String? appState}) async {
    try {
      final response = await aiService.send(message, appState: appState);
      return Right(response);
    } catch (e) {
      return Left(StateError(e.toString()));
    }
  }
}