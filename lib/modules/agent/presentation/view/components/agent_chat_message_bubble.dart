import 'package:ai_operator_app/shared/theme/app_fonts.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class AgentChatMessageBubble extends StatelessWidget {
  const AgentChatMessageBubble({
    required this.message,
    required this.isUser,
    super.key,
  });

  final String message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final minBubbleWidth = MediaQuery.sizeOf(context).width * 0.15;  
    final maxBubbleWidth = MediaQuery.sizeOf(context).width * 0.75;

    return Align(
      alignment: isUser
          ? AlignmentDirectional.topEnd
          : AlignmentDirectional.topStart,
      child: Container(
        constraints: BoxConstraints(minWidth: minBubbleWidth, maxWidth: maxBubbleWidth),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        margin: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isUser ? colorScheme.primary : colorScheme.tertiary,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: MarkdownBody(
          data: message,
          styleSheet: _messageStyleSheet(theme, colorScheme.onPrimary),
        ),
      ),
    );
  }

  MarkdownStyleSheet _messageStyleSheet(ThemeData theme, Color textColor) {
    final body = theme.textTheme.bodyMedium?.copyWith(color: textColor);
    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: body,
      strong: body?.copyWith(fontWeight: FontWeight.bold),
      em: body?.copyWith(fontStyle: FontStyle.italic),
      listBullet: body,
      listIndent: AppSpacing.lg,
      blockquote: body,
      h1: body?.copyWith(fontWeight: FontWeight.bold, fontSize: AppFonts.sizeXl),
      h2: body?.copyWith(fontWeight: FontWeight.bold, fontSize: AppFonts.sizeLg),
      h3: body?.copyWith(fontWeight: FontWeight.bold, fontSize: AppFonts.sizeMd),
    );
  }
}
