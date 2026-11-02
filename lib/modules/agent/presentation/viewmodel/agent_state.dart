import 'package:flutter_app_copilot/flutter_app_copilot.dart';

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