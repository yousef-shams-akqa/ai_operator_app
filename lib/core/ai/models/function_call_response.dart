/// A function call requested by the model.
///
/// [functionArgs] come from the model and are untrusted: they may be missing
/// or have the wrong types.
class FunctionCallResponse {
  final String functionName;
  final Map<String, dynamic> functionArgs;

  FunctionCallResponse(this.functionName, this.functionArgs);
}
