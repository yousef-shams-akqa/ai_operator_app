import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AgentChatInput extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;
  const AgentChatInput({super.key, required this.onSend, required this.isLoading});

  @override
  State<AgentChatInput> createState() => _AgentChatInputState();
}

class _AgentChatInputState extends State<AgentChatInput> {
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: colorScheme.outline,
          height: AppSizes.borderWidth,
        ),
        Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          margin: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: TextField(
            enabled: !widget.isLoading,
            controller: textController,
            decoration: InputDecoration(
              hintText: AppStrings.agentMessageHint,
              suffixIcon: IconButton(
                onPressed: widget.isLoading 
                ? null 
                : ()  {
                  widget.onSend(textController.text);
                  textController.clear();
                },
                icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
