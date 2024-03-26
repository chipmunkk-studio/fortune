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
import 'package:fortune/data/remote/api/service/fortune_ad_service.dart';
import 'package:fortune/data/remote/api/service/marker_service.dart';
import 'package:fortune/data/remote/datasource/fortune_ad_datasource.dart';
import 'package:fortune/data/remote/datasource/fortune_user_datasource.dart';
import 'package:fortune/data/remote/datasource/marker_datasource.dart';
import 'package:fortune/data/remote/repository/fortune_user_repository_impl.dart';
import 'package:fortune/data/remote/repository/normal_auth_repository_impl.dart';
import 'package:fortune/domain/repository/fortune_ad_repository.dart';
import 'package:fortune/domain/repository/fortune_user_repository.dart';
import 'package:fortune/domain/repository/marker_repository.dart';
import 'package:fortune/domain/usecase/marker_list_use_case.dart';
import 'package:fortune/domain/usecase/marker_obtain_use_case.dart';
import 'package:fortune/domain/usecase/register_user_use_case.dart';
import 'package:fortune/domain/usecase/request_email_verify_code_use_case.dart';
import 'package:fortune/domain/usecase/show_ad_complete_use_case.dart';
import 'package:fortune/domain/usecase/user_me_use_case.dart';
import 'package:fortune/firebase_options.dart';
import 'package:fortune/presentation-v2/fortune_ad/bloc/fortune_ad.dart';
import 'package:fortune/presentation-v2/main/bloc/main_bloc.dart';
import 'package:fortune/presentation-v2/obtain/bloc/fortune_obtain.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_item_secure_storage/single_item_secure_storage.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/observed_storage.dart';
import 'package:single_item_storage/storage.dart';
import 'package:universal_html/html.dart' hide Storage;

import 'data/error/fortune_error_mapper.dart';
import 'data/remote/api/service/fortune_user_service.dart';
import 'data/remote/api/service/no_auth_service.dart';
import 'data/remote/datasource/no_auth_datasource.dart';
import 'data/remote/network/api_service_provider.dart';
import 'data/remote/network/auth_helper_jwt.dart';
import 'data/remote/network/credential/user_credential.dart';
import 'data/remote/repository/fortune_ad_repository_impl.dart';
import 'data/remote/repository/marker_repository_impl.dart';
import 'domain/repository/no_auth_repository.dart';
import 'domain/usecase/verify_email_use_case.dart';
import 'env.dart';
import 'presentation-v2/agreeterms/bloc/agree_terms_bloc.dart';
import 'presentation-v2/fortune_ad/admanager/fortune_ad.dart';
import 'presentation-v2/login/bloc/login_bloc.dart';
import 'presentation-v2/permission/bloc/request_permission_bloc.dart';
import 'presentation-v2/termsdetail/bloc/terms_detail_bloc.dart';
import 'presentation-v2/verifycode/bloc/verify_code_bloc.dart';

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
    _initService(apiProvider);
    _initDataSource();
    _initRepository();
    _initUseCase();
    _initAppBloc();

    /// 믹스 패널.
    await _initMixPanel();

    /// FCM todo 나중에 작업할 때 다시 활성화.
    await _initFCM();
  } catch (e) {
    rethrow;
  }
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
_initService(ApiServiceProvider apiProvider) {
  serviceLocator

    /// 에러 맵퍼.
    ..registerLazySingleton<FortuneErrorMapper>(() => FortuneErrorMapper())

    /// normal.(인증이 필요하지 않은 서비스)
    ..registerLazySingleton<AuthHelperJwt>(() => apiProvider.getAuthHelperJwt())
    ..registerLazySingleton<NoAuthService>(() => apiProvider.getNoAuthService())

    /// abnormal.(인증이 필요한 서비스)
    ..registerLazySingleton<MarkerService>(() => apiProvider.getMarkerService())
    ..registerLazySingleton<FortuneUserService>(() => apiProvider.getFortuneUserService())
    ..registerLazySingleton<FortuneAdService>(() => apiProvider.getFortuneAdService());
}

_initUseCase() {
  serviceLocator
    ..registerLazySingleton<RequestEmailVerifyCodeUseCase>(
      () => RequestEmailVerifyCodeUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<RegisterUserUseCase>(
      () => RegisterUserUseCase(
        noAuthRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<UserMeUseCase>(
      () => UserMeUseCase(
        userRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<MarkerListUseCase>(
      () => MarkerListUseCase(
        markerRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<ShowAdCompleteUseCase>(
      () => ShowAdCompleteUseCase(
        fortuneAdRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<MarkerObtainUseCase>(
      () => MarkerObtainUseCase(
        markerRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<VerifyEmailUseCase>(
      () => VerifyEmailUseCase(
        authRepository: serviceLocator(),
      ),
    );
}

_initRepository() {
  serviceLocator
    ..registerLazySingleton<FortuneUserRepository>(
      () => FortuneUserRepositoryImpl(
        fortuneUserDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    )
    ..registerLazySingleton<MarkerRepository>(
      () => MarkerRepositoryImpl(
        markerDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    )
    ..registerLazySingleton<FortuneAdRepository>(
      () => FortuneAdRepositoryImpl(
        fortuneAdDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    )
    ..registerLazySingleton<NoAuthRepository>(
      () => NoAuthRepositoryImpl(
        noAuthDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    );
}

_initDataSource() {
  serviceLocator
    ..registerLazySingleton<FortuneUserDataSource>(
      () => FortuneUserDataSourceImpl(
        fortuneUserService: serviceLocator(),
      ),
    )
    ..registerLazySingleton<MarkerDataSource>(
      () => MarkerDataSourceImpl(
        markerService: serviceLocator(),
      ),
    )
    ..registerLazySingleton<FortuneAdDataSource>(
      () => FortuneAdDataSourceImpl(
        fortuneAdService: serviceLocator(),
      ),
    )
    ..registerLazySingleton<NoAuthDataSource>(
      () => NoAuthDataSourceImpl(
        normalAuthService: serviceLocator(),
      ),
    );
}

_initAppBloc() {
  serviceLocator
    ..registerFactory(
      () => MainBloc(
        environment: serviceLocator(),
        tracker: serviceLocator(),
        userMeUseCase: serviceLocator(),
        markerListUseCase: serviceLocator(),
        adManager: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => LoginBloc(
        requestEmailVerifyCodeUseCase: serviceLocator<RequestEmailVerifyCodeUseCase>(),
      ),
    )
    ..registerFactory(
      () => FortuneAdBloc(
        showAdCompleteUseCase: serviceLocator(),
        adManager: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FortuneObtainBloc(
        markerObtainUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RequestPermissionBloc(
        userStorage: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => TermsDetailBloc(
        getTermsByIndexUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => VerifyCodeBloc(
        verifyEmailUseCase: serviceLocator(),
        registerUserUseCase: serviceLocator(),
        userStorage: serviceLocator(),
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
  serviceLocator
    ..registerLazySingleton<Environment>(() => environment)
    ..registerFactory<FortuneAdManager>(
      () => FortuneAdManager(
        priorityOrder: remoteConfig.adSourcePriority,
      ),
    );
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
