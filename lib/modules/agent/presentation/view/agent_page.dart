import 'package:ai_operator_app/core/ai/service/gemini/gemini_ai_service.dart';
import 'package:ai_operator_app/core/navigation/app_router.dart';
import 'package:ai_operator_app/core/ai/helpers/app_router_context.dart';
import 'package:ai_operator_app/modules/agent/domain/usecases/send_ai_request_usecase.dart';
import 'package:ai_operator_app/modules/agent/presentation/view/components/agent_chat_input.dart';
import 'package:ai_operator_app/modules/agent/presentation/view/components/agent_chat_messages_list.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_state.dart'
    show AgentState, AgentLoading, AgentError;
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_viewmodel.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgentPage extends StatelessWidget {
  const AgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AgentViewmodel(
        sendAiRequestUsecase: SendAiRequestUsecase(aiService: GeminiAIService.instance!),
        appRouterContext: AppRouterContext(appRouter),
      ),
      child: BlocConsumer<AgentViewmodel, AgentState>(
        listener: (context, state) {
          if (state is AgentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.toString())),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AgentLoading;
          return Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.goToAgent),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: AgentChatMessagesList(
                      chatMessages: state.chatMessages,
                      isLoading: isLoading,
                    ),
                  ),
                  AgentChatInput(
                    onSend: (message) => context.read<AgentViewmodel>().sendMessage(message),
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
