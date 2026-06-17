

// Все твои импорты на месте
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'feature/auth/bloc/auth_cubit.dart';
import 'feature/auth/repository/auth_repository.dart';
import 'feature/auth/repository/auth_repository_impl.dart';
import 'feature/trips/repozitory/trip_repozitory.dart';
import 'feature/splash/splash_screen.dart';

// Импорты для истории поездок

import 'feature/history/bloc/history_cubit.dart';
import 'feature/history/history_screen.dart';

void main() async {
  // Обязательная строчка для работы асинхронного кода перед запуском приложения
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Безопасное подключение к Supabase
    await Supabase.initialize(
      url: 'https://qrlqslkbridskjarczls.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFybHFzbGticmlkc2tqYXJjemxzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE4OTUsImV4cCI6MjA5NzA4Nzg5NX0.bXjljgiJ6hTJOrpMD2rGlXDes4_n5UP1uOWXVC22Znc',
    );
    print('✅ Supabase успешно запущен!');
  } catch (e) {
    // Если в Хроме падает из-за бэкенда, мы увидим это в консоли, но приложение не вылетит
    print('❌ ОШИБКА ИНИЦИАЛИЗАЦИИ SUPABASE: $e');
  }
  // Запуск приложения с DevicePreview
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => const TaxiApp(),
    ),
  );
}

class TaxiApp extends StatelessWidget {
  const TaxiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<HistoryCubit>(
            create: (context) => HistoryCubit(
              context.read<TripRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Taxi Абхазия',
          debugShowCheckedModeBanner: false,

          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,

          theme: AppTheme.light,
          home: const SplashScreen(), // Сразу открываем твой экран истории
        ),
      );
  }
}