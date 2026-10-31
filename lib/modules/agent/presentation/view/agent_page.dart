import 'package:ai_operator_app/modules/agent/presentation/view/components/agent_chat_input.dart';
import 'package:ai_operator_app/modules/agent/presentation/view/components/agent_chat_messages_list.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_state.dart'
    show AgentState, AgentLoading, AgentError;
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_viewmodel.dart';
import 'package:ai_operator_app/shared/components/app_snackbar.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgentPage extends StatelessWidget {
  const AgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AgentViewmodel, AgentState>(
      listener: (context, state) {
        if (state is AgentError) {
          AppSnackBar.showError(context, state.error.toString());
        }
      },
      builder: (context, state) {
        final isLoading = state is AgentLoading;
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.goToAgent),
            actions: [
              IconButton(
                onPressed: () => context.read<AgentViewmodel>().clearChat(),
                icon: const Icon(Icons.refresh_outlined),
              ),
            ],
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
    );
  }
}
