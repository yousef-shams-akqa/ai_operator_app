import 'package:flutter_app_copilot/flutter_app_copilot.dart';

class SendAiRequestUsecase {
  final AIService aiService;

  SendAiRequestUsecase({required this.aiService});

  Future<Either<Error, String>> call(List<ChatMessage> messages) async {
    try {
      final response = await aiService.send(messages);
      return Right(response);
    } on AIProviderFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(StateError(e.toString()));
    }
  }
}
