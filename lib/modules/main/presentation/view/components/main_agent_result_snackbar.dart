import '../../../../../../packages/flutter_ai_operator/lib/src/models/chat_message.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_state.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_viewmodel.dart';
import 'package:ai_operator_app/shared/components/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Builds and shows snack bars for completed agent requests on the main shell.
class MainAgentResultSnackBar {
  MainAgentResultSnackBar._();

  static const int _maxContentLines = 4;

  static bool shouldListen(AgentState previous, AgentState current) {
    return previous is AgentLoading &&
        (current is AgentLoaded || current is AgentError);
  }

  static void handleAgentState(BuildContext context, AgentState state) {
    if (state is AgentError) {
      AppSnackBar.showError(context, state.error.toString());
      return;
    }
    if (state is AgentLoaded) {
      final response = latestModelMessage(state.chatMessages);
      if (response == null || response.isEmpty) {
        return;
      }
      AppSnackBar.showMessage(
        context,
        response,
        maxLines: _maxContentLines,
      );
    }
  }

  static String? latestModelMessage(List<ChatMessage> messages) {
    for (final message in messages.reversed) {
      if (message.type == ChatMessageType.model) {
        return message.message;
      }
    }
    return null;
  }
}

class MainAgentResultSnackBarListener extends StatelessWidget {
  const MainAgentResultSnackBarListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AgentViewmodel, AgentState>(
      listenWhen: MainAgentResultSnackBar.shouldListen,
      listener: MainAgentResultSnackBar.handleAgentState,
      child: child,
    );
  }
}
