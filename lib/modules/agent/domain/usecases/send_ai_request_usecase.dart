
import 'package:flutter_ai_operator/flutter_ai_operator.dart';
import 'package:either_dart/either.dart';

class SendAiRequestUsecase {
  final AIService aiService;

  SendAiRequestUsecase({required this.aiService});

  Future<Either<Error, String>> call(String requestForAI, List<ChatMessage> chatHistory, {String? appContext}) async {
    try {
      final response = await aiService.send(requestForAI, chatHistory, appContext: appContext);
      return Right(response);
    } catch (e) {
      return Left(StateError(e.toString()));
    }
  }
}