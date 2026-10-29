import 'package:ai_operator_app/core/ai/models/ai_configuration.dart';
import 'package:ai_operator_app/core/ai/models/function_declaration_mapper.dart';
import 'package:ai_operator_app/core/ai/service/ai_service.dart';
import 'package:ai_operator_app/shared/constants/app_constants.dart';
import 'package:firebase_ai/firebase_ai.dart';

class GeminiAIService implements AIService {
  GenerativeModel? model;
  final String modelName;
  final AIConfiguration configuration;

  GeminiAIService({
    this.modelName = AppConstants.geminiModel,
    this.configuration = const AIConfiguration(
      systemPrompt: '',
      functionDeclarations: [],
    ),
  }) {
    final tools = FunctionDeclarationMapper.toolsFromDeclarations(
      configuration.functionDeclarations,
    );
    model = FirebaseAI.googleAI().generativeModel(
      model: modelName,
      systemInstruction: Content.text(configuration.systemPrompt),
      tools: tools.isEmpty ? null : tools,
    );
  }


  @override
  Future<String> send(String requestForAI) async {
    if (model == null) { return ''; }
    final response = await model!.generateContent([Content.text(requestForAI)]);
    return response.text ?? '';
    // for (final functionCall in response.functionCalls) {
    //   final functionName = functionCall.name;
    //   final functionArgs = functionCall.args;
    //   final functionResult = await _model.callFunction(functionName, functionArgs);
    //   return functionResult;
    // }

    // return response.text;
  }
  
}