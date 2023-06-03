import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/notification/notification_ext.dart';
import 'package:foresh_flutter/core/util/analytics.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/service/auth_service.dart';
import 'package:foresh_flutter/data/supabase/service/board_service.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_respository.dart';
import 'package:foresh_flutter/firebase_options.dart';
import 'package:foresh_flutter/presentation/agreeterms/bloc/agree_terms_bloc.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/login/bloc/login_bloc.dart';
import 'package:foresh_flutter/presentation/permission/bloc/request_permission_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/notification/notification_manager.dart';
import 'env.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 앱로거
  initAppLogger();

  /// Firebase 초기화.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// 개발 환경 설정.
  await initEnvironment();

  /// Supabase
  await Supabase.initialize(
    url: serviceLocator<Environment>().remoteConfig.baseUrl,
    anonKey: serviceLocator<Environment>().remoteConfig.anonKey,
    debug: false,
  );

  /// 파이어 베이스 FCM
  await initFCM();

  /// 파이어베이스 analytics.
  final fortuneAnalytics = FortuneAnalytics(FirebaseAnalytics.instance);

  /// 다국어 설정.
  await EasyLocalization.ensureInitialized();

  /// 로컬 데이터 - Preference.
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  /// 파이어베이스 애널리틱스.
  serviceLocator.registerLazySingleton<FortuneAnalytics>(() => fortuneAnalytics);

  /// Router.
  serviceLocator.registerLazySingleton<FortuneRouter>(() => FortuneRouter()..init());

  /// SharedPreferences
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  await initSupabase();
}

initSupabase() async {
  /// data.
  await _initService();

  /// domain.
  await _initRepository();

  /// Bloc.
  await _initBloc();
}

/// FCM
initFCM() async {
  final FortuneNotificationsManager notificationsManager = FortuneNotificationsManager(initializeSettings);
  notificationsManager.setupPushNotifications();
  serviceLocator.registerLazySingleton<FortuneNotificationsManager>(() => notificationsManager);
}

/// 환경설정.
initEnvironment() async {
  final Environment environment = Environment.create(
    remoteConfig: await getRemoteConfigArgs(),
  )..init();

  serviceLocator.registerLazySingleton<Environment>(() => environment);
}

/// 로거.
initAppLogger() {
  final appLogger = AppLogger(
    Logger(
      printer: PrettyPrinter(
        methodCount: 3,
        // 보이는 메소드 콜 갯수.
        errorMethodCount: 8,
        // 보이는 에러 메소드 콜 갯수.
        lineLength: 120,
        // 라인 넓이.
        colors: true,
        // 컬러적용.
        printEmojis: true,
        // 이모티콘 보이기.
        printTime: false, // 타임스탬프.
      ),
    ),
  );

  /// 앱로거.
  serviceLocator.registerLazySingleton<AppLogger>(() => appLogger);
}

/// Service.
_initService() {
  serviceLocator
    ..registerLazySingleton<UserService>(
      () => UserService(
        Supabase.instance.client,
      ),
    )
    ..registerLazySingleton<BoardService>(
      () => BoardService(
        Supabase.instance.client,
        serviceLocator<UserService>(),
      ),
    )
    ..registerLazySingleton<AuthService>(
      () => AuthService(
        client: Supabase.instance.client,
        authClient: Supabase.instance.client.auth,
        preferences: serviceLocator<SharedPreferences>(),
      ),
    );
}

/// Repository
_initRepository() {
  serviceLocator
    ..registerLazySingleton<UserRepository>(
      () => UserRepository(
        serviceLocator<UserService>(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        serviceLocator<AuthService>(),
        serviceLocator<UserService>(),
      ),
    );
}

/// Bloc.
_initBloc() {
  serviceLocator
    ..registerFactory(
      () => LoginBloc(
        authRepository: serviceLocator<AuthRepository>(),
        userRepository: serviceLocator<UserRepository>(),
      ),
    )
    ..registerFactory(
      () => RequestPermissionBloc(),
    )
    ..registerFactory(
      () => AgreeTermsBloc(
        authRepository: serviceLocator<AuthRepository>(),
        userRepository: serviceLocator<UserRepository>(),
      ),
    );
}
