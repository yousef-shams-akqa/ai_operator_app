class FunctionCallResponse {
  final String functionName;
  final Map<String, dynamic> functionArgs;

  FunctionCallResponse(this.functionName, this.functionArgs);
}