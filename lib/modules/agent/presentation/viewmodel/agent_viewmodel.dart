import 'package:ai_operator_app/core/ai/models/chat_message.dart';
import 'package:ai_operator_app/modules/agent/domain/usecases/send_ai_request_usecase.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_operator_app/core/ai/helpers/app_router_context.dart';
import 'package:go_router/go_router.dart';

class AgentViewmodel extends Cubit<AgentState> {
  final SendAiRequestUsecase sendAiRequestUsecase;
  final GoRouter router;

  AgentViewmodel({required this.sendAiRequestUsecase, required this.router})
      : super(AgentInitial(chatMessages: []));

  Future<void> sendMessage(String userMessage) async {
    final currentChatHistory = state.chatMessages.toList();
    final newChatHistory = state.chatMessages + [ChatMessage.user(userMessage)];

    emit(AgentLoading(chatMessages: newChatHistory));
    final appContext = router.getRouterContext();
    final result = await sendAiRequestUsecase.call(userMessage, currentChatHistory, appContext: appContext);

    result.fold(
      (error) {
        emit(AgentError(chatMessages: currentChatHistory, error: error));
      },
      (response) {
        final newChatHistoryWithAiResponse = newChatHistory + [ChatMessage.model(response)];
        emit(AgentLoaded(chatMessages: newChatHistoryWithAiResponse));
      },
    );
  }

  void clearChat() {
    emit(AgentInitial(chatMessages: []));
  }
}