import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/notification/notification_ext.dart';
import 'package:foresh_flutter/core/notification/notification_manager.dart';
import 'package:foresh_flutter/core/util/analytics.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/repository/auth_repository_impl.dart';
import 'package:foresh_flutter/data/supabase/repository/ingredient_respository_impl.dart';
import 'package:foresh_flutter/data/supabase/repository/marker_respository_impl.dart';
import 'package:foresh_flutter/data/supabase/repository/obtain_history_respository_impl.dart';
import 'package:foresh_flutter/data/supabase/repository/user_respository_impl.dart';
import 'package:foresh_flutter/data/supabase/service/auth_service.dart';
import 'package:foresh_flutter/data/supabase/service/board_service.dart';
import 'package:foresh_flutter/data/supabase/service/ingredient_service.dart';
import 'package:foresh_flutter/data/supabase/service/marker_service.dart';
import 'package:foresh_flutter/data/supabase/service/mission/mission_reward_service.dart';
import 'package:foresh_flutter/data/supabase/service/obtain_history_service.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_alarm_reward_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_obtain_histories_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_terms_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_user_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/main_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/obtain_marker_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/sign_up_or_in_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/verify_phone_number_use_case.dart';
import 'package:foresh_flutter/firebase_options.dart';
import 'package:foresh_flutter/presentation/agreeterms/bloc/agree_terms_bloc.dart';
import 'package:foresh_flutter/presentation/alarmfeed/bloc/alarm_feed_bloc.dart';
import 'package:foresh_flutter/presentation/alarmreward/bloc/alarm_reward.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/login/bloc/login_bloc.dart';
import 'package:foresh_flutter/presentation/main/bloc/main.dart';
import 'package:foresh_flutter/presentation/missions/bloc/missions.dart';
import 'package:foresh_flutter/presentation/obtainhistory/bloc/obtain_history.dart';
import 'package:foresh_flutter/presentation/permission/bloc/request_permission_bloc.dart';
import 'package:foresh_flutter/presentation/verifycode/bloc/verify_code.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/supabase/repository/alarm_feeds_repository_impl.dart';
import 'data/supabase/repository/alarm_reward_repository_impl.dart';
import 'data/supabase/repository/missions_respository_impl.dart';
import 'data/supabase/service/alarm_feeds_service.dart';
import 'data/supabase/service/alarm_reward_history_service.dart';
import 'data/supabase/service/alarm_reward_info_service.dart';
import 'data/supabase/service/mission/mission_clear_conditions_service.dart';
import 'data/supabase/service/mission/mission_clear_user_service.dart';
import 'data/supabase/service/mission/missions_service.dart';
import 'domain/supabase/repository/alarm_feeds_repository.dart';
import 'domain/supabase/repository/alarm_reward_repository.dart';
import 'domain/supabase/repository/mission_respository.dart';
import 'domain/supabase/usecase/get_alarm_feed_use_case.dart';
import 'domain/supabase/usecase/get_mission_clear_conditions_use_case.dart';
import 'domain/supabase/usecase/get_mission_detail_use_case.dart';
import 'domain/supabase/usecase/get_missions_use_case.dart';
import 'domain/supabase/usecase/obtain_alarm_reward_use_case.dart';
import 'domain/supabase/usecase/post_mission_clear_use_case.dart';
import 'env.dart';
import 'presentation/missiondetail/bloc/mission_detail_bloc.dart';

final serviceLocator = GetIt.instance;
final FortuneDialogService dialogService = FortuneDialogService();

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

  /// OneSignal푸시 알람.
  // await OneSignalManager.init();
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

  /// UseCase.
  await _initUseCase();

  /// Bloc.
  await _initBloc();
}

/// 환경설정.
initEnvironment() async {
  final Environment environment = Environment.create(
    remoteConfig: await getRemoteConfigArgs(),
  )..init();

  serviceLocator.registerLazySingleton<Environment>(() => environment);
}

initFCM() async {
  final FortuneNotificationsManager notificationsManager = FortuneNotificationsManager(initializeSettings);
  notificationsManager.setupPushNotifications();
  serviceLocator.registerLazySingleton<FortuneNotificationsManager>(() => notificationsManager);
}

/// 로거.
initAppLogger() {
  final appLogger = AppLogger(
    Logger(
      printer: PrettyPrinter(
        methodCount: 6,
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
      () => UserService(),
    )
    ..registerLazySingleton<BoardService>(
      () => BoardService(
        Supabase.instance.client,
        serviceLocator<UserService>(),
      ),
    )
    ..registerLazySingleton<IngredientService>(
      () => IngredientService(
        Supabase.instance.client,
      ),
    )
    ..registerLazySingleton<ObtainHistoryService>(
      () => ObtainHistoryService(
        Supabase.instance.client,
      ),
    )
    ..registerLazySingleton<MarkerService>(
      () => MarkerService(
        Supabase.instance.client,
        env: serviceLocator(),
      ),
    )
    ..registerLazySingleton<MissionsService>(
      () => MissionsService(),
    )
    ..registerLazySingleton<MissionRewardService>(
      () => MissionRewardService(),
    )
    ..registerLazySingleton<AlarmRewardHistoryService>(
      () => AlarmRewardHistoryService(),
    )
    ..registerLazySingleton<MissionClearUserService>(
      () => MissionClearUserService(
        Supabase.instance.client,
      ),
    )
    ..registerLazySingleton<AlarmFeedsService>(
      () => AlarmFeedsService(),
    )
    ..registerLazySingleton<AlarmRewardInfoService>(
      () => AlarmRewardInfoService(),
    )
    ..registerLazySingleton<MissionsClearConditionsService>(
      () => MissionsClearConditionsService(),
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
      () => UserRepositoryImpl(
        serviceLocator<UserService>(),
      ),
    )
    ..registerLazySingleton<IngredientRepository>(
      () => IngredientRepositoryImpl(serviceLocator<IngredientService>()),
    )
    ..registerLazySingleton<MarkerRepository>(
      () => MarkerRepositoryImpl(
        serviceLocator<MarkerService>(),
      ),
    )
    ..registerLazySingleton<ObtainHistoryRepository>(
      () => ObtainHistoryRepositoryImpl(
        serviceLocator<ObtainHistoryService>(),
      ),
    )
    ..registerLazySingleton<AlarmFeedsRepository>(
      () => AlarmFeedsRepositoryImpl(
        alarmFeedsService: serviceLocator<AlarmFeedsService>(),
      ),
    )
    ..registerLazySingleton<AlarmRewardRepository>(
      () => AlarmRewardRepositoryImpl(
        rewardsService: serviceLocator<AlarmRewardHistoryService>(),
        eventRewardInfoService: serviceLocator<AlarmRewardInfoService>(),
      ),
    )
    ..registerLazySingleton<MissionsRepository>(
      () => MissionsRepositoryImpl(
        missionNormalService: serviceLocator<MissionsService>(),
        missionClearConditionsService: serviceLocator<MissionsClearConditionsService>(),
        missionClearUserService: serviceLocator<MissionClearUserService>(),
        missionRewardService: serviceLocator<MissionRewardService>(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator<AuthService>(),
        serviceLocator<UserService>(),
      ),
    );
}

_initUseCase() async {
  serviceLocator
    ..registerLazySingleton<ObtainMarkerUseCase>(
      () => ObtainMarkerUseCase(
        markerRepository: serviceLocator(),
        userRepository: serviceLocator(),
        eventNoticesRepository: serviceLocator(),
        obtainHistoryRepository: serviceLocator(),
        missionsRepository: serviceLocator(),
        rewardRepository: serviceLocator(),
        ingredientRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetObtainHistoriesUseCase>(
      () => GetObtainHistoriesUseCase(
        obtainHistoryRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetUserUseCase>(
      () => GetUserUseCase(
        userRepository: serviceLocator(),
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<VerifyPhoneNumberUseCase>(
      () => VerifyPhoneNumberUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SignUpOrInUseCase>(
      () => SignUpOrInUseCase(
        authRepository: serviceLocator(),
        userRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetTermsUseCase>(
      () => GetTermsUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetMissionsUseCase>(
      () => GetMissionsUseCase(
        missionRepository: serviceLocator(),
        obtainHistoryRepository: serviceLocator(),
        userRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetMissionClearConditionsUseCase>(
      () => GetMissionClearConditionsUseCase(
        missionRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetMissionDetailUseCase>(
      () => GetMissionDetailUseCase(
        missionRepository: serviceLocator(),
        userRepository: serviceLocator(),
        obtainHistoryRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<PostMissionClearUseCase>(
      () => PostMissionClearUseCase(
        missionRepository: serviceLocator(),
        userRepository: serviceLocator(),
        obtainHistoryRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetAlarmFeedUseCase>(
      () => GetAlarmFeedUseCase(
        userRepository: serviceLocator(),
        alarmFeedsRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetAlarmRewardUseCase>(
      () => GetAlarmRewardUseCase(
        alarmRewardRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<ObtainAlarmRewardUseCase>(
      () => ObtainAlarmRewardUseCase(
        userRepository: serviceLocator(),
        obtainHistoryRepository: serviceLocator(),
        rewardRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<MainUseCase>(
      () => MainUseCase(
        remoteConfig: serviceLocator<Environment>().remoteConfig,
        ingredientRepository: serviceLocator(),
        markerRepository: serviceLocator(),
        userRepository: serviceLocator(),
        obtainHistoryRepository: serviceLocator(),
        userNoticesRepository: serviceLocator(),
      ),
    );
}

/// Bloc.
_initBloc() {
  serviceLocator
    ..registerFactory(
      () => LoginBloc(
        getUserUseCase: serviceLocator<GetUserUseCase>(),
        signUpOrInUseCase: serviceLocator<SignUpOrInUseCase>(),
      ),
    )
    ..registerFactory(
      () => RequestPermissionBloc(),
    )
    ..registerFactory(
      () => AlarmFeedBloc(
        getAlarmFeedUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ObtainHistoryBloc(
        getObtainHistoriesUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => MainBloc(
        remoteConfig: serviceLocator<Environment>().remoteConfig,
        mainUseCase: serviceLocator(),
        obtainMarkerUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AlarmRewardBloc(
        getAlarmRewardUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => MissionsBloc(
        getAllMissionsUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => MissionDetailBloc(
        getMissionDetailUseCase: serviceLocator(),
        postMissionClearUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => VerifyCodeBloc(
        verifyPhoneNumberUseCase: serviceLocator(),
        signUpOrInUseCase: serviceLocator(),
      ),
    )
    // ..registerFactory(
    //   () => MissionDetailRelayBloc(
    //     getMissionDetailUseCase: serviceLocator(),
    //     postMissionClearUseCase: serviceLocator(),
    //   ),
    // )
    ..registerFactory(
      () => AgreeTermsBloc(
        getTermsUseCase: serviceLocator(),
      ),
    );
}
