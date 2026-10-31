sealed class AgentState {
  final List<String> chatMessages;

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