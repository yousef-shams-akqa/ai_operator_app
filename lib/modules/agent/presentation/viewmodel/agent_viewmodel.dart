import 'package:flutter_ai_operator/flutter_ai_operator.dart';
import 'package:ai_operator_app/modules/agent/domain/usecases/send_ai_request_usecase.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AgentViewmodel extends Cubit<AgentState> {
  final SendAiRequestUsecase sendAiRequestUsecase;
  final GoRouter router;
  int _requestId = 0;

  AgentViewmodel({required this.sendAiRequestUsecase, required this.router})
    : super(AgentInitial(chatMessages: []));

  Future<void> sendMessage(String userMessage) async {
    if (isClosed || state is AgentLoading) return;

    final requestId = ++_requestId;
    final currentChatHistory = state.chatMessages.toList();
    final newChatHistory = state.chatMessages + [ChatMessage.user(userMessage)];

    emit(AgentLoading(chatMessages: newChatHistory));
    final appContext = router.getRouterContext();
    final result = await sendAiRequestUsecase.call(
      newChatHistory,
      appContext: appContext,
    );
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (error) {
        emit(AgentError(chatMessages: currentChatHistory, error: error));
      },
      (response) {
        final newChatHistoryWithAiResponse =
            newChatHistory + [ChatMessage.model(response)];
        emit(AgentLoaded(chatMessages: newChatHistoryWithAiResponse));
      },
    );
  }

  void clearChat() {
    if (isClosed) return;
    _requestId++;
    emit(AgentInitial(chatMessages: []));
  }
}
