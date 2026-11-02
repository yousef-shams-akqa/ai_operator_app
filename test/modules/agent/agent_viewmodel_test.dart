import 'dart:async';

import 'package:ai_operator_app/modules/agent/domain/usecases/send_ai_request_usecase.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_state.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_viewmodel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_copilot/flutter_app_copilot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GoRouter router;
  late _RecordingAIService ai;
  late AgentViewmodel viewmodel;

  setUp(() {
    router = GoRouter(
      routes: [GoRoute(path: '/', builder: (_, _) => const SizedBox())],
    );
    ai = _RecordingAIService();
    viewmodel = AgentViewmodel(
      sendAiRequestUsecase: SendAiRequestUsecase(aiService: ai),
      router: router,
    );
  });

  tearDown(() async {
    await viewmodel.close();
    router.dispose();
  });

  test(
    'sends the latest user message once and retains prior exchanges',
    () async {
      final first = viewmodel.sendMessage('Hello');
      expect(viewmodel.state, isA<AgentLoading>());
      expect(ai.requests.single.single.message, 'Hello');
      expect(ai.contexts.single, contains('Route tree: /'));
      ai.replies.single.complete('Hi');
      await first;

      final second = viewmodel.sendMessage('Save dark mode');
      expect(ai.requests.last.map((message) => message.message), [
        'Hello',
        'Hi',
        'Save dark mode',
      ]);
      expect(ai.requests.last.map((message) => message.type), [
        ChatMessageType.user,
        ChatMessageType.model,
        ChatMessageType.user,
      ]);
      ai.replies.last.complete('Saved');
      await second;

      expect(viewmodel.state, isA<AgentLoaded>());
      expect(viewmodel.state.chatMessages.map((message) => message.message), [
        'Hello',
        'Hi',
        'Save dark mode',
        'Saved',
      ]);
    },
  );

  test(
    'preserves a provider failure and rolls back the pending user message',
    () async {
      final first = viewmodel.sendMessage('Hello');
      ai.replies.single.complete('Hi');
      await first;

      final failed = viewmodel.sendMessage('Save dark mode');
      final failure = AIProviderInvalidInputFailure();
      ai.replies.last.completeError(failure);
      await failed;

      expect(viewmodel.state, isA<AgentError>());
      expect((viewmodel.state as AgentError).error, same(failure));
      expect(viewmodel.state.chatMessages.map((message) => message.message), [
        'Hello',
        'Hi',
      ]);

      final retry = viewmodel.sendMessage('Save dark mode');
      expect(ai.requests.last.map((message) => message.message), [
        'Hello',
        'Hi',
        'Save dark mode',
      ]);
      ai.replies.last.complete('Saved');
      await retry;
    },
  );

  test('ignores additional sends while a reply is pending', () async {
    final pending = viewmodel.sendMessage('First');
    await viewmodel.sendMessage('Second');

    expect(ai.requests, hasLength(1));
    expect(viewmodel.state.chatMessages.single.message, 'First');
    ai.replies.single.complete('First reply');
    await pending;
  });

  test(
    'ignores an old reply after clearing and starting another conversation',
    () async {
      final oldRequest = viewmodel.sendMessage('Old conversation');
      viewmodel.clearChat();
      expect(viewmodel.state, isA<AgentInitial>());

      final newRequest = viewmodel.sendMessage('New conversation');
      ai.replies.last.complete('New reply');
      await newRequest;
      ai.replies.first.complete('Old reply');
      await oldRequest;

      expect(viewmodel.state.chatMessages.map((message) => message.message), [
        'New conversation',
        'New reply',
      ]);
    },
  );

  test('does not emit a reply after the view model closes', () async {
    final pending = viewmodel.sendMessage('Hello');
    await viewmodel.close();
    ai.replies.single.complete('Hi');

    await expectLater(pending, completes);
    expect(viewmodel.isClosed, isTrue);
    expect(viewmodel.state.chatMessages.single.message, 'Hello');
  });
}

class _RecordingAIService extends Fake implements AIService {
  final requests = <List<ChatMessage>>[];
  final contexts = <String?>[];
  final replies = <Completer<String>>[];

  @override
  Future<String> send(List<ChatMessage> messages, {String? appContext}) {
    requests.add(List<ChatMessage>.unmodifiable(messages));
    contexts.add(appContext);
    final reply = Completer<String>();
    replies.add(reply);
    return reply.future;
  }
}
