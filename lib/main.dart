import 'package:ai_operator_app/core/ai/helpers/app_router_context.dart';
import 'package:ai_operator_app/core/ai/service/gemini/gemini_ai_service.dart';
import 'package:ai_operator_app/core/initializer/app_initializer.dart';
import 'package:ai_operator_app/core/navigation/app_router.dart';
import 'package:ai_operator_app/modules/agent/domain/usecases/send_ai_request_usecase.dart';
import 'package:ai_operator_app/modules/agent/presentation/viewmodel/agent_viewmodel.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AgentViewmodel(
        sendAiRequestUsecase: SendAiRequestUsecase(aiService: GeminiAIService.instance!),
        appRouterContext: AppRouterContext(appRouter),
      ),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: appThemeMode,
        builder: (BuildContext context, ThemeMode value, Widget? child) {
          return MaterialApp.router(
            title: AppStrings.appName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: value,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
