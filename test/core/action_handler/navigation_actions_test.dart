import 'package:ai_operator_app/core/action_handler/ai_action_handler_impl.dart';
import 'package:ai_operator_app/core/navigation/app_router.dart';
import 'package:ai_operator_app/shared/ai/ai_functions_definitions_list.dart';
import 'package:flutter_app_copilot/flutter_app_copilot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FunctionParameter locationOf(FunctionDefinition definition) => definition
      .parameters
      .firstWhere((parameter) => parameter.key == NavigationInput.locationKey);

  final navigationDefinitions = AIFunctionsDefinitionsList.all.where(
    (definition) => NavigationMethod.fromFunctionName(definition.name) != null,
  );

  test('navigation tools come from the package', () {
    expect(
      navigationDefinitions.map((definition) => definition.name),
      NavigationMethod.values.map((method) => method.functionName),
    );
  });

  test('every route the model may open exists in the router', () {
    final allowed = locationOf(
      navigationDefinitions.first,
    ).value.possibleValues;

    expect(allowed, isNotEmpty);
    expect(appRouter.routePaths(), containsAll(allowed));
  });

  test('the handler reports bad navigation arguments to the model', () async {
    final handler = AiActionHandlerImpl(actions: const []);

    final result = await handler.handle(
      FunctionCallResponse(NavigationMethod.push.functionName, {}),
    );

    expect(result.left, isA<NavigationFailure>());
  });
}
