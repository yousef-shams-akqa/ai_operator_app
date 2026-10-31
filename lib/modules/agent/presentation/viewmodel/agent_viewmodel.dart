import 'package:ai_operator_app/modules/agent/domain/usecases/send_ai_request_usecase.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_operator_app/core/ai/helpers/app_router_context.dart';

class AgentViewmodel extends Cubit<AgentState> {
  final SendAiRequestUsecase sendAiRequestUsecase;
  final AppRouterContext appRouterContext;

  AgentViewmodel({required this.sendAiRequestUsecase, required this.appRouterContext}) 
  : super(AgentInitial(chatMessages: []));

  Future<void> sendMessage(String message) async {
    emit(AgentLoaded(chatMessages: state.chatMessages + [message]));

    emit(AgentLoading(chatMessages: state.chatMessages));
    final appState = appRouterContext.getRouterContext();
    final result = await sendAiRequestUsecase.call(message, appState: appState);
    result.fold(
      (error) => emit(AgentError(chatMessages: state.chatMessages, error: error)),
      (response) => emit(AgentLoaded(chatMessages: state.chatMessages + [response])),
    );
  }
}