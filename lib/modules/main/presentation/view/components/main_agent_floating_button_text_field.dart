import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_fonts.dart';
import 'package:ai_operator_app/shared/theme/app_colors.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class MainAgentFloatingButtonTextField extends StatefulWidget {
  const MainAgentFloatingButtonTextField({
    required this.onSubmitted,
    required this.onClosed,
    super.key,
  });

  final ValueChanged<String> onSubmitted;
  final VoidCallback onClosed;

  @override
  State<MainAgentFloatingButtonTextField> createState() =>
      _MainAgentFloatingButtonTextFieldState();
}

class _MainAgentFloatingButtonTextFieldState
    extends State<MainAgentFloatingButtonTextField> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool canSubmit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSubmitted(_textController.text);
    widget.onClosed();
  }

  @override
  Widget build(BuildContext context) {
    final fieldTextStyle = AppFonts.bodySmall.copyWith();
    final hintTextStyle = AppFonts.bodySmall.copyWith();

    final iconSize = AppSizes.iconMd;
    final iconPadding = AppSpacing.md;
    final iconButtonSize = iconSize + iconPadding;
    final iconButtonStyle = IconButton.styleFrom(
      minimumSize: Size(iconButtonSize, iconButtonSize),
      maximumSize: Size(iconButtonSize, iconButtonSize),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );

    final iconSlotConstraints = BoxConstraints(
      minWidth: iconButtonSize, maxWidth: iconButtonSize,
      minHeight: iconButtonSize, maxHeight: iconButtonSize,
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        style: fieldTextStyle,
        onChanged: (text) {
          final newCanSubmit = text.trim().isNotEmpty;
          if(newCanSubmit != canSubmit) {
            setState(() {
              canSubmit = newCanSubmit;
            });
          }
        },
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          hintText: AppStrings.agentMessageHintSecondary,
          hintStyle: hintTextStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          prefixIconConstraints: iconSlotConstraints,
          suffixIconConstraints: iconSlotConstraints,
          prefixIcon: IconButton(
            style: iconButtonStyle,
            onPressed: widget.onClosed,
            icon: Icon(Icons.close, size: iconSize),
          ),
          suffixIcon: IconButton(
            style: iconButtonStyle,
            onPressed: canSubmit ? _submit : null,
            icon: Icon(Icons.send, color: canSubmit ? AppColors.primary : AppColors.textDisabled, size: iconSize),
          ),
        ),
      ),
    );
  }
}
