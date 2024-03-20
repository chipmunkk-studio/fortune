import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/navigation/fortune_web_router.dart';
import 'package:fortune/core/notification/notification_ext.dart';
import 'package:fortune/core/notification/notification_manager.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/widgets/dialog/fortune_dialog.dart';
import 'package:fortune/core/widgets/dialog/fortune_dialog2.dart';
import 'package:fortune/data/local/datasource/local_datasource.dart';
import 'package:fortune/data/local/repository/local_repository_impl.dart';
import 'package:fortune/data/remote/datasource/auth_normal_datasource.dart';
import 'package:fortune/data/supabase/repository/ingredient_respository_impl.dart';
import 'package:fortune/data/supabase/repository/marker_respository_impl.dart';
import 'package:fortune/data/supabase/repository/obtain_history_respository_impl.dart';
import 'package:fortune/data/supabase/repository/support_repository_impl.dart';
import 'package:fortune/data/supabase/repository/user_respository_impl.dart';
import 'package:fortune/data/supabase/service/auth_service.dart';
import 'package:fortune/data/supabase/service/country_info_service.dart';
import 'package:fortune/data/supabase/service/ingredient_service.dart';
import 'package:fortune/data/supabase/service/marker_service.dart';
import 'package:fortune/data/supabase/service/mission/mission_clear_user_histories_service.dart';
import 'package:fortune/data/supabase/service/mission/mission_reward_service.dart';
import 'package:fortune/data/supabase/service/obtain_history_service.dart';
import 'package:fortune/data/supabase/service/post_service.dart';
import 'package:fortune/data/supabase/service/support_service.dart';
import 'package:fortune/data/supabase/service/user_service.dart';
import 'package:fortune/domain/local/local_respository.dart';
import 'package:fortune/domain/supabase/repository/country_info_repository.dart';
import 'package:fortune/domain/supabase/repository/ingredient_respository.dart';
import 'package:fortune/domain/supabase/repository/marker_respository.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/support_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/usecase/check_verify_sms_time_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_coinbox_remain_time_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_coinbox_stop_time_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_faqs_usecase.dart';
import 'package:fortune/domain/supabase/usecase/get_my_ingredients_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_notices_usecase.dart';
import 'package:fortune/domain/supabase/usecase/get_obtain_histories_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_privacy_policy_usecase.dart';
import 'package:fortune/domain/supabase/usecase/get_show_ad_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_terms_by_index_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_terms_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_user_use_case.dart';
import 'package:fortune/domain/supabase/usecase/grade_guide_use_case.dart';
import 'package:fortune/domain/supabase/usecase/main_use_case.dart';
import 'package:fortune/domain/supabase/usecase/my_page_use_case.dart';
import 'package:fortune/domain/supabase/usecase/obtain_marker_default_use_case.dart';
import 'package:fortune/domain/supabase/usecase/obtain_marker_main_use_case.dart';
import 'package:fortune/domain/supabase/usecase/ranking_use_case.dart';
import 'package:fortune/domain/supabase/usecase/ranking_user_by_mission_clear_count_case.dart';
import 'package:fortune/domain/supabase/usecase/read_alarm_feed_use_case.dart';
import 'package:fortune/domain/supabase/usecase/receive_alarm_reward_use_case.dart';
import 'package:fortune/domain/supabase/usecase/reduce_coin_use_case.dart';
import 'package:fortune/domain/supabase/usecase/set_coinbox_remain_time_use_case.dart';
import 'package:fortune/domain/supabase/usecase/set_coinbox_stop_time_use_case.dart';
import 'package:fortune/domain/supabase/usecase/set_show_ad_use_case.dart';
import 'package:fortune/domain/supabase/usecase/sign_in_with_email_use_case.dart';
import 'package:fortune/domain/supabase/usecase/sign_up_or_in_use_case.dart';
import 'package:fortune/domain/supabase/usecase/update_user_nick_name_use_case.dart';
import 'package:fortune/domain/supabase/usecase/update_user_profile_use_case.dart';
import 'package:fortune/domain/supabase/usecase/withdrawal_use_case.dart';
import 'package:fortune/domain/usecase/request_email_verify_code_use_case.dart';
import 'package:fortune/firebase_options.dart';
import 'package:fortune/presentation-web/agreeterms/bloc/web_agree_terms.dart';
import 'package:fortune/presentation-web/login/bloc/web_login.dart';
import 'package:fortune/presentation-web/retire/bloc/web_retire.dart';
import 'package:fortune/presentation-web/verifycode/bloc/web_verify_code.dart';
import 'package:fortune/presentation-web/writepost/bloc/write_post.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_item_secure_storage/single_item_secure_storage.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/observed_storage.dart';
import 'package:single_item_storage/storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_html/html.dart' hide Storage;

import 'data/error/fortune_error_mapper.dart';
import 'data/remote/api/service/main_service.dart';
import 'data/remote/api/service/normal_auth_service.dart';
import 'data/remote/api/service/normal_user_service.dart';
import 'data/remote/api/service/user_service.dart';
import 'data/remote/core/api_service_provider.dart';
import 'data/remote/core/auth_helper_jwt.dart';
import 'data/remote/core/credential/user_credential.dart';
import 'data/remote/repository/auth_normal_repository_impl.dart';
import 'data/supabase/repository/alarm_feeds_repository_impl.dart';
import 'data/supabase/repository/alarm_reward_repository_impl.dart';
import 'data/supabase/repository/auth_repository_impl.dart';
import 'data/supabase/repository/country_info_repository_impl.dart';
import 'data/supabase/repository/missions_respository_impl.dart';
import 'data/supabase/service/alarm_feeds_service.dart';
import 'data/supabase/service/alarm_reward_history_service.dart';
import 'data/supabase/service/alarm_reward_info_service.dart';
import 'data/supabase/service/mission/mission_clear_conditions_service.dart';
import 'data/supabase/service/mission/missions_service.dart';
import 'domain/repository/auth_normal_repository.dart';
import 'domain/supabase/repository/alarm_feeds_repository.dart';
import 'domain/supabase/repository/alarm_reward_repository.dart';
import 'domain/supabase/repository/auth_repository.dart';
import 'domain/supabase/repository/mission_respository.dart';
import 'domain/supabase/usecase/get_alarm_feed_use_case.dart';
import 'domain/supabase/usecase/get_app_update.dart';
import 'domain/supabase/usecase/get_country_info_use_case.dart';
import 'domain/supabase/usecase/get_giftbox_remain_time_use_case.dart';
import 'domain/supabase/usecase/get_giftbox_stop_time_use_case.dart';
import 'domain/supabase/usecase/get_ingredients_by_type_use_case.dart';
import 'domain/supabase/usecase/get_mission_clear_conditions_use_case.dart';
import 'domain/supabase/usecase/get_mission_detail_use_case.dart';
import 'domain/supabase/usecase/get_missions_use_case.dart';
import 'domain/supabase/usecase/my_missions_use_case.dart';
import 'domain/supabase/usecase/nick_name_use_case.dart';
import 'domain/supabase/usecase/post_mission_clear_use_case.dart';
import 'domain/supabase/usecase/set_giftbox_remain_time_use_case.dart';
import 'domain/supabase/usecase/set_giftbox_stop_time_use_case.dart';
import 'domain/usecase/verify_email_use_case.dart';
import 'env.dart';
import 'presentation-v2/agreeterms/bloc/agree_terms_bloc.dart';
import 'presentation-v2/login/bloc/login_bloc.dart';
import 'presentation-v2/permission/bloc/request_permission_bloc.dart';
import 'presentation-v2/termsdetail/bloc/terms_detail_bloc.dart';
import 'presentation-v2/verifycode/bloc/verify_code_bloc.dart';
import 'presentation/support/privacypolicy/bloc/privacy_policy_bloc.dart';

final serviceLocator = GetIt.instance;
final FortuneDialogService dialogService = FortuneDialogService();
final FortuneDialogService2 dialogService2 = FortuneDialogService2();

Future<void> init() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    /// 다국어 설정.
    await EasyLocalization.ensureInitialized();

    /// Firebase 초기화.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// 앱로거
    await initAppLogger();

    /// 개발 환경 설정.
    await initEnvironment(kIsWeb);

    /// 로컬 데이터 - Preference.
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    serviceLocator
      ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)
      ..registerLazySingleton<LocalDataSource>(
        () => LocalDataSourceImpl(
          remoteConfig: serviceLocator<Environment>().remoteConfig,
        ),
      );

    /// 로컬 데이터 - Storage.
    final ObservedStorage<UserCredential> userStorage = ObservedStorage<UserCredential>(
      CachedStorage(
        SecureStorage(
          itemKey: 'data.models.user-credential',
          fromMap: (map) => UserCredential.fromJson(map),
          toMap: (user) => user.toJson(),
          iosOptions: const IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
            synchronizable: true,
          ),
          androidOptions: const AndroidOptions(
            encryptedSharedPreferences: false,
          ),
        ),
      ),
    );
    serviceLocator.registerLazySingleton<Storage<UserCredential>>(() => userStorage);

    /// 서비스 프로바이더.
    ApiServiceProvider apiProvider = ApiServiceProvider(
      baseUrl: serviceLocator<Environment>().remoteConfig.baseUrl,
      userStore: userStorage,
    );

    /// Router.
    initRouter(kIsWeb);

    /// 서비스 init
    await _initService(apiProvider);

    /// 믹스 패널.
    await _initMixPanel();

    /// FCM todo 나중에 작업할 때 다시 활성화.
    await _initFCM();

    /// Supabase
    await initSupabase(kIsWeb);
  } catch (e) {
    rethrow;
  }
}

/// Service.
_initService(ApiServiceProvider apiProvider) {
  serviceLocator
    ..registerLazySingleton<FortuneErrorMapper>(() => FortuneErrorMapper())

    /// normal.(인증이 필요하지 않은 서비스)
    ..registerLazySingleton<AuthHelperJwt>(() => apiProvider.getAuthHelperJwt())
    ..registerLazySingleton<NormalUserService>(() => apiProvider.getMemberNormalService())
    ..registerLazySingleton<NormalAuthService>(() => apiProvider.getAuthNormalService())

    /// abnormal.(인증이 필요한 서비스)
    ..registerLazySingleton<UserService>(() => apiProvider.getUserService())
    ..registerLazySingleton<MainService>(() => apiProvider.getMarkerService());

  _initUseCase2();
  _initRepository2();
  _initDataSource();
}

_initUseCase2() async {
  serviceLocator
    ..registerLazySingleton<RequestEmailVerifyCodeUseCase>(
      () => RequestEmailVerifyCodeUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<VerifyEmailUseCase>(
      () => VerifyEmailUseCase(
        authRepository: serviceLocator(),
      ),
    );
}

_initRepository2() async {
  serviceLocator
    ..registerLazySingleton<AuthNormalRepository>(
      () => AuthNormalRepositoryImpl(
        authDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    );
}

_initDataSource() async {
  serviceLocator
    ..registerLazySingleton<AuthNormalDataSource>(
      () => AuthNormalDataSourceImpl(
        normalAuthService: serviceLocator(),
      ),
    );
}

_initAppBloc() {
  serviceLocator
    ..registerFactory(
      () => LoginBloc(
        requestEmailVerifyCodeUseCase: serviceLocator<RequestEmailVerifyCodeUseCase>(),
      ),
    )
    ..registerFactory(
      () => RequestPermissionBloc(),
    )
    ..registerFactory(
      () => TermsDetailBloc(
        getTermsByIndexUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => VerifyCodeBloc(
        verifyEmailUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AgreeTermsBloc(
        getTermsUseCase: serviceLocator(),
        tracker: serviceLocator(),
      ),
    );
}

_initMixPanel() async {
  final remoteConfig = serviceLocator<Environment>().remoteConfig;

  /// 믹스 패널 추가 > 웹이 아닐 경우 에만 지원.
  Mixpanel? mixpanel;
  if (!kIsWeb) {
    mixpanel = await Mixpanel.init(
      kReleaseMode ? remoteConfig.mixpanelReleaseToken : remoteConfig.mixpanelDevelopToken,
      trackAutomaticEvents: false,
    );
    mixpanel.setLoggingEnabled(true);
  }

  serviceLocator.registerLazySingleton<MixpanelTracker>(() => MixpanelTracker.init(mixpanel));
}

initRouter(bool kIsWeb) {
  kIsWeb
      ? serviceLocator.registerLazySingleton<FortuneWebRouter>(() => FortuneWebRouter()..init())
      : serviceLocator.registerLazySingleton<FortuneAppRouter>(() => FortuneAppRouter()..init());

  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  serviceLocator.registerSingleton<RouteObserver<PageRoute>>(routeObserver);
}

initSupabase(bool kIsWeb) async {
  /// data.
  await _initSupabaseService();

  /// domain.
  await _initRepository();

  /// UseCase.
  await _initUseCase();

  /// App Bloc.
  await _initBloc(kIsWeb);
}

/// 환경설정.
initEnvironment(bool kIsWeb) async {
  Uri uri = Uri.parse(window.location.href);
  // 현재 웹에서 실행된 웹인건지, 앱에서 실행된 웹인지 결정함.
  // source가 app이면 앱에서 실행된 웹임.
  String source = uri.queryParameters['source'] ?? 'web';

  final remoteConfig = await getRemoteConfigArgs();

  final Environment environment = Environment.create(
    remoteConfig: remoteConfig,
    source: source,
  )..init(kIsWeb);
  serviceLocator.registerLazySingleton<Environment>(() => environment);
}

/// FCM
_initFCM() async {
  final FortuneNotificationsManager notificationsManager = FortuneNotificationsManager(
    initializeSettings,
    localDataSource: serviceLocator<LocalDataSource>(),
  );
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
_initSupabaseService() {
  serviceLocator
    ..registerLazySingleton<FortuneUserService>(
      () => FortuneUserService(notificationManager: serviceLocator()),
    )
    ..registerLazySingleton<IngredientService>(
      () => IngredientService(),
    )
    ..registerLazySingleton<SupportService>(
      () => SupportService(),
    )
    ..registerLazySingleton<ObtainHistoryService>(
      () => ObtainHistoryService(),
    )
    ..registerLazySingleton<MarkerService>(
      () => MarkerService(env: serviceLocator()),
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
    ..registerLazySingleton<MissionClearUserHistoriesService>(
      () => MissionClearUserHistoriesService(),
    )
    ..registerLazySingleton<AlarmFeedsService>(
      () => AlarmFeedsService(),
    )
    ..registerLazySingleton<AlarmRewardInfoService>(
      () => AlarmRewardInfoService(),
    )
    ..registerLazySingleton<CountryInfoService>(
      () => CountryInfoService(),
    )
    ..registerLazySingleton<MissionsClearConditionsService>(
      () => MissionsClearConditionsService(),
    )
    ..registerLazySingleton<PostService>(
      () => PostService(),
    )
    ..registerLazySingleton<AuthService>(
      () => AuthService(
        preferences: serviceLocator<SharedPreferences>(),
      ),
    );
}

/// Repository
_initRepository() {
  serviceLocator
    ..registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        serviceLocator<FortuneUserService>(),
        serviceLocator<MixpanelTracker>(),
      ),
    )
    ..registerLazySingleton<LocalRepository>(
      () => LocalRepositoryImpl(
        localDataSource: serviceLocator<LocalDataSource>(),
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
    ..registerLazySingleton<SupportRepository>(
      () => SupportRepositoryImpl(
        supportService: serviceLocator<SupportService>(),
      ),
    )
    ..registerLazySingleton<CountryInfoRepository>(
      () => CountryInfoRepositoryImpl(
        countryInfoService: serviceLocator<CountryInfoService>(),
      ),
    )
    ..registerLazySingleton<AlarmRewardRepository>(
      () => AlarmRewardRepositoryImpl(
        rewardsService: serviceLocator<AlarmRewardHistoryService>(),
        alarmRewardInfoService: serviceLocator<AlarmRewardInfoService>(),
      ),
    )
    ..registerLazySingleton<MissionsRepository>(
      () => MissionsRepositoryImpl(
        missionNormalService: serviceLocator<MissionsService>(),
        missionClearConditionsService: serviceLocator<MissionsClearConditionsService>(),
        missionClearUserService: serviceLocator<MissionClearUserHistoriesService>(),
        missionRewardService: serviceLocator<MissionRewardService>(),
        userService: serviceLocator<FortuneUserService>(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator<AuthService>(),
        serviceLocator<FortuneUserService>(),
        serviceLocator<MixpanelTracker>(),
      ),
    );
}

_initUseCase() async {
  serviceLocator
    ..registerLazySingleton<ObtainMarkerMainUseCase>(
      () => ObtainMarkerMainUseCase(
        markerRepository: serviceLocator(),
        userRepository: serviceLocator(),
        alarmFeedsRepository: serviceLocator(),
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
    ..registerLazySingleton<RankingUserByMissionClearCountUseCase>(
      () => RankingUserByMissionClearCountUseCase(
        userRepository: serviceLocator(),
        missionsRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetTermsByIndexUseCase>(
      () => GetTermsByIndexUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SignUpOrInUseCase>(
      () => SignUpOrInUseCase(
        authRepository: serviceLocator(),
        userRepository: serviceLocator(),
        env: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetTermsUseCase>(
      () => GetTermsUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetNoticesUseCase>(
      () => GetNoticesUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetFaqsUseCase>(
      () => GetFaqsUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<ReadAlarmFeedUseCase>(
      () => ReadAlarmFeedUseCase(
        userRepository: serviceLocator(),
        alarmFeedsRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetShowAdUseCase>(
      () => GetShowAdUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetCountryInfoUseCase>(
      () => GetCountryInfoUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SetGiftboxRemainTimeUseCase>(
      () => SetGiftboxRemainTimeUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetGiftboxRemainTimeUseCase>(
      () => GetGiftboxRemainTimeUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SetGiftboxStopTimeUseCase>(
      () => SetGiftboxStopTimeUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetGiftboxStopTimeUseCase>(
      () => GetGiftboxStopTimeUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SetCoinboxRemainTimeUseCase>(
      () => SetCoinboxRemainTimeUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetCoinboxRemainTimeUseCase>(
      () => GetCoinboxRemainTimeUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SetCoinboxStopTimeUseCase>(
      () => SetCoinboxStopTimeUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetCoinboxStopTimeUseCase>(
      () => GetCoinboxStopTimeUseCase(
        repository: serviceLocator(),
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
    ..registerLazySingleton<GetMyIngredientsUseCase>(
      () => GetMyIngredientsUseCase(
        ingredientRepository: serviceLocator(),
        userRepository: serviceLocator(),
        obtainHistoryRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SignInWithEmailUseCase>(
      () => SignInWithEmailUseCase(
        authRepository: serviceLocator<AuthRepository>(),
      ),
    )
    ..registerLazySingleton<RankingUseCase>(
      () => RankingUseCase(
        userRepository: serviceLocator<UserRepository>(),
        missionsRepository: serviceLocator<MissionsRepository>(),
      ),
    )
    ..registerLazySingleton<GetAlarmFeedUseCase>(
      () => GetAlarmFeedUseCase(
        userRepository: serviceLocator(),
        alarmFeedsRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<CheckVerifySmsTimeUseCase>(
      () => CheckVerifySmsTimeUseCase(
        localRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<MyPageUseCase>(
      () => MyPageUseCase(
        userRepository: serviceLocator(),
        localRepository: serviceLocator(),
        supportRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetAppUpdate>(
      () => GetAppUpdate(
        supportRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<MyMissionsUseCase>(
      () => MyMissionsUseCase(
        missionsRepository: serviceLocator(),
        userRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<NickNameUseCase>(
      () => NickNameUseCase(
        userRepository: serviceLocator(),
        localRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<UpdateUserProfileUseCase>(
      () => UpdateUserProfileUseCase(
        userRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GradeGuideUseCase>(
      () => GradeGuideUseCase(
        userRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<UpdateUserNickNameUseCase>(
      () => UpdateUserNickNameUseCase(
        userRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<WithdrawalUseCase>(
      () => WithdrawalUseCase(
        userRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<ReduceCoinUseCase>(
      () => ReduceCoinUseCase(
        userRepository: serviceLocator(),
        ingredientRepository: serviceLocator(),
        rewardRepository: serviceLocator(),
        alarmFeedsRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetPrivacyPolicyUseCase>(
      () => GetPrivacyPolicyUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<ReceiveAlarmRewardUseCase>(
      () => ReceiveAlarmRewardUseCase(
        userRepository: serviceLocator(),
        rewardRepository: serviceLocator(),
        alarmFeedsRepository: serviceLocator(),
        historyRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SetShowAdUseCase>(
      () => SetShowAdUseCase(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<ObtainMarkerDefaultUseCase>(
      () => ObtainMarkerDefaultUseCase(
        userRepository: serviceLocator(),
        historyRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetIngredientsByTypeUseCase>(
      () => GetIngredientsByTypeUseCase(
        ingredientRepository: serviceLocator(),
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
        missionsRepository: serviceLocator(),
      ),
    );
}

_initBloc(bool kIsWeb) async {
  kIsWeb ? await _initWebBloc() : await _initAppBloc();
}

_initWebBloc() {
  serviceLocator
    ..registerFactory(
      () => WebAgreeTermsBloc(
        getTermsUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => WebVerifyCodeBloc(
        verifyEmailUseCase: serviceLocator(),
        checkVerifySmsTimeUseCase: serviceLocator(),
        withdrawalUseCase: serviceLocator(),
        signUpOrInUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => WebRetireBloc(
        getUserUseCase: serviceLocator(),
        signInWithEmailUseCase: serviceLocator(),
        env: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => PrivacyPolicyBloc(
        getPrivacyPolicyUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => TermsDetailBloc(
        getTermsByIndexUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => WritePostBloc(),
    )
    ..registerFactory(
      () => WebLoginBloc(
        getUserUseCase: serviceLocator<GetUserUseCase>(),
        signInWithEmailUseCase: serviceLocator<SignInWithEmailUseCase>(),
        env: serviceLocator<Environment>(),
      ),
    );
}
