import 'package:ai_operator_app/modules/main/presentation/view/components/main_agent_floating_button_text_field.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:flutter/material.dart';

// This button is used to quickly send a message to the agent through the main page floating action button.
// Clicking the button will toggle a bool state value, and toggling that will switch between
// display this floating button or display a text field with a button to send a message to the agent.
class MainAgentFloatingButton extends StatefulWidget {
  const MainAgentFloatingButton({
    required this.onMessageSubmitted,
    this.isAgentLoading = false,
    super.key,
  });

  final ValueChanged<String> onMessageSubmitted;
  final bool isAgentLoading;

  @override
  State<MainAgentFloatingButton> createState() => _MainAgentFloatingButtonState();
}

class _MainAgentFloatingButtonState extends State<MainAgentFloatingButton> {
  bool _isTextFieldVisible = false;

  @override
  Widget build(BuildContext context) {
    if (_isTextFieldVisible) {
      return MainAgentFloatingButtonTextField(
        onSubmitted: widget.onMessageSubmitted,
        onClosed: () {
          setState(() {
            _isTextFieldVisible = false;
          });
        },
      );
    }

    final iconColor = _floatingActionButtonIconColor(context);

    return FloatingActionButton(
      onPressed: widget.isAgentLoading
          ? null
          : () {
              setState(() {
                _isTextFieldVisible = true;
              });
            },
      child: widget.isAgentLoading
          ? SizedBox(
              height: AppSizes.iconMd,
              width: AppSizes.iconMd,
              child: CircularProgressIndicator(
                strokeWidth: AppSizes.borderWidthThick,
                color: iconColor,
              ),
            )
          : Icon(
              Icons.auto_awesome_outlined,
              size: AppSizes.iconLg,
              color: iconColor,
            ),
    );
  }

  Color _floatingActionButtonIconColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.floatingActionButtonTheme.foregroundColor ??
        theme.colorScheme.onPrimaryContainer;
  }
}
