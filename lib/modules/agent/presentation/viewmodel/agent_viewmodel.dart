import 'package:flutter_app_copilot/flutter_app_copilot.dart';
import 'package:ai_operator_app/modules/agent/domain/usecases/send_ai_request_usecase.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgentViewmodel extends Cubit<AgentState> {
  final SendAiRequestUsecase sendAiRequestUsecase;
  int _requestId = 0;

  AgentViewmodel({required this.sendAiRequestUsecase})
    : super(AgentInitial(chatMessages: []));

  Future<void> sendMessage(String userMessage) async {
    if (isClosed || state is AgentLoading) return;

    final requestId = ++_requestId;
    final currentChatHistory = state.chatMessages.toList();
    final newChatHistory = state.chatMessages + [ChatMessage.user(userMessage)];

    emit(AgentLoading(chatMessages: newChatHistory));
    final result = await sendAiRequestUsecase.call(newChatHistory);
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
