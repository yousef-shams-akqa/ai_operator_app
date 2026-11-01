import 'package:ai_operator_app/core/ai/constants/ai_constants.dart';
import 'package:ai_operator_app/core/ai/models/ai_provider.dart';
import 'package:ai_operator_app/core/ai/failures/ai_provider_failure.dart';
import 'package:either_dart/either.dart';
// Tests intentionally live under lib; flutter_test remains a dev dependency.
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'helpers/ai_service_fixture.dart';

void main() {
  for (final provider in AIProvider.values) {
    group('${provider.name} AIService contract', () {
      late AIServiceFixture fixture;

      setUp(() => fixture = AIServiceFixture(provider));

      test('executes the requested tool and returns the final reply', () async {
        fixture.responses.addAll([
          fixture.toolReply(),
          fixture.textReply('Saved'),
        ]);

        expect(await fixture.service.send('Save dark mode', []), 'Saved');

        final call = fixture.actionHandler.calls.single;
        expect(call.functionName, 'save_value');
        expect(call.functionArgs, {'value': 'dark'});
        expect(fixture.toolResult, {'result': 'saved'});
        expect(fixture.requests, hasLength(2));
      });

      test('returns an action failure to the model and continues', () async {
        final failure = StateError('Permission denied');
        fixture.actionHandler.result = Left(failure);
        fixture.responses.addAll([
          fixture.toolReply(),
          fixture.textReply('Could not save'),
        ]);

        expect(
          await fixture.service.send('Save dark mode', []),
          'Could not save',
        );

        expect(fixture.actionHandler.calls, hasLength(1));
        expect(fixture.toolResult, {'error': failure.toString()});
        expect(fixture.requests, hasLength(2));
      });

      test(
        'surfaces a reply without text as an empty-response failure',
        () async {
          fixture.responses.add(fixture.emptyReply());

          await expectLater(
            fixture.service.send('Hello', []),
            throwsA(isA<AIProviderEmptyResponseFailure>()),
          );

          expect(fixture.actionHandler.calls, isEmpty);
        },
      );

      test('terminates repeated tool calls at the configured limit', () async {
        fixture.responses.addAll(
          List.generate(
            AIConstants.maxToolRounds + 1,
            (_) => fixture.toolReply(),
          ),
        );

        await expectLater(
          fixture.service.send('Save dark mode', []),
          throwsA(isA<AIProviderTooManyCallsFailure>()),
        );

        expect(
          fixture.actionHandler.calls,
          hasLength(AIConstants.maxToolRounds),
        );
        // Gemini reads one follow-up response to detect another tool request.
        expect(
          fixture.requests.length,
          lessThanOrEqualTo(AIConstants.maxToolRounds + 1),
        );
      });
    });
  }
}
