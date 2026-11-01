/// One earlier turn of the conversation, resent to the provider on every
/// request. [ChatMessageType.model] is sent as `assistant` to OpenAI and Claude.
class ChatMessage {
  final String message;
  final ChatMessageType type;

  ChatMessage({required this.message, required this.type});

  factory ChatMessage.user(String message) {
    return ChatMessage(message: message, type: ChatMessageType.user);
  }

  factory ChatMessage.model(String message) {
    return ChatMessage(message: message, type: ChatMessageType.model);
  }
}

enum ChatMessageType {
  user,
  model,
}
