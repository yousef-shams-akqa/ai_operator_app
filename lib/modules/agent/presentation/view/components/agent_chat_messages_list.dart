import 'package:ai_operator_app/core/ai/models/chat_message.dart';
import 'package:ai_operator_app/modules/agent/presentation/view/components/agent_chat_message_bubble.dart';
import 'package:ai_operator_app/shared/constants/app_constants.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AgentChatMessagesList extends StatefulWidget {
  final List<ChatMessage> chatMessages;
  final bool isLoading;
  const AgentChatMessagesList({super.key, required this.chatMessages, required this.isLoading});

  @override
  State<AgentChatMessagesList> createState() => _AgentChatMessagesListState();
}

class _AgentChatMessagesListState extends State<AgentChatMessagesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant AgentChatMessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.chatMessages.isNotEmpty) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppConstants.defaultAnimationDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.isLoading ? widget.chatMessages.length + 1 : widget.chatMessages.length,
      itemBuilder: (context, index) {
        if (widget.isLoading && index == widget.chatMessages.length) {
          return Center(
            child: Container(
              width: AppSizes.iconMd,
              height: AppSizes.iconMd,
              margin: EdgeInsets.only(top: AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return AgentChatMessageBubble(
          isUser: widget.chatMessages[index].type == ChatMessageType.user,
          message: widget.chatMessages[index].message,
        );
      },
    );
  }
}
