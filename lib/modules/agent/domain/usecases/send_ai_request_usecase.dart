import 'package:flutter_ai_operator/flutter_ai_operator.dart';

class SendAiRequestUsecase {
  final AIService aiService;

  SendAiRequestUsecase({required this.aiService});

  Future<Either<Error, String>> call(
    List<ChatMessage> messages, {
    String? appContext,
  }) async {
    try {
      final response = await aiService.send(messages, appContext: appContext);
      return Right(response);
    } on AIProviderFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(StateError(e.toString()));
    }
  }
}
