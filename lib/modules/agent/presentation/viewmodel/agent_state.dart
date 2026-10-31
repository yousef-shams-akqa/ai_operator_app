import 'package:ai_operator_app/core/ai/models/chat_message.dart';

sealed class AgentState {
  final List<ChatMessage> chatMessages;

  AgentState({required this.chatMessages});
}

class AgentInitial extends AgentState {
  AgentInitial({required super.chatMessages});
}

class AgentLoading extends AgentState {
  AgentLoading({required super.chatMessages});
}

class AgentLoaded extends AgentState {
  AgentLoaded({required super.chatMessages});
}

class AgentError extends AgentState {
  final Error error;

  AgentError({required super.chatMessages, required this.error});
}