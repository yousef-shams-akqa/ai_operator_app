import 'package:ai_operator_app/core/data/repositories/user_preferences_repository_impl.dart';
import 'package:ai_operator_app/core/storage/app_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await AppPreferences.initialize();
  });

  test('watchProfileName emits current value then updates after save',
      () async {
    final repository = UserPreferencesRepositoryImpl(AppPreferences());

    final values = <String?>[];
    final subscription = repository.watchProfileName().listen(values.add);

    await Future<void>.delayed(Duration.zero);
    expect(values, [null]);

    await repository.saveProfileName('Ada');
    await Future<void>.delayed(Duration.zero);
    expect(values, [null, 'Ada']);

    await subscription.cancel();
  });

  test('watchDarkModeEnabled emits current value then updates after save',
      () async {
    final repository = UserPreferencesRepositoryImpl(AppPreferences());

    final values = <bool>[];
    final subscription = repository.watchDarkModeEnabled().listen(values.add);

    await Future<void>.delayed(Duration.zero);
    expect(values, [false]);

    await repository.saveDarkModeEnabled(true);
    await Future<void>.delayed(Duration.zero);
    expect(values, [false, true]);

    await subscription.cancel();
  });
}
