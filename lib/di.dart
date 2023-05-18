import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_error_mapper.dart';
import 'package:foresh_flutter/core/network/api/service/common_service.dart';
import 'package:foresh_flutter/core/network/api/service/main_service.dart';
import 'package:foresh_flutter/core/network/api/service/normal/normal_auth_service.dart';
import 'package:foresh_flutter/core/network/api/service/normal/normal_user_service.dart';
import 'package:foresh_flutter/core/network/api/service/reward_service.dart';
import 'package:foresh_flutter/core/network/api/service/user_service.dart';
import 'package:foresh_flutter/core/network/api_service_provider.dart';
import 'package:foresh_flutter/core/network/auth_helper_jwt.dart';
import 'package:foresh_flutter/core/network/credential/user_credential.dart';
import 'package:foresh_flutter/core/notification/notification_ext.dart';
import 'package:foresh_flutter/core/util/analytics.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/datasources/common_datasource.dart';
import 'package:foresh_flutter/data/datasources/local_datasource.dart';
import 'package:foresh_flutter/data/datasources/main_datasource.dart';
import 'package:foresh_flutter/data/datasources/reward_datasource.dart';
import 'package:foresh_flutter/data/datasources/user/auth_normal_datasource.dart';
import 'package:foresh_flutter/data/datasources/user/user_normal_datasource.dart';
import 'package:foresh_flutter/data/repositories/auth_normal_repository_impl.dart';
import 'package:foresh_flutter/data/repositories/common_repository_impl.dart';
import 'package:foresh_flutter/data/repositories/main_repository_impl.dart';
import 'package:foresh_flutter/data/repositories/reward_repository_impl.dart';
import 'package:foresh_flutter/data/repositories/user_normal_repository_impl.dart';
import 'package:foresh_flutter/domain/repositories/auth_normal_remote_repository.dart';
import 'package:foresh_flutter/domain/repositories/common_repository.dart';
import 'package:foresh_flutter/domain/repositories/marker_repository.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';
import 'package:foresh_flutter/domain/repositories/user_normal_remote_repository.dart';
import 'package:foresh_flutter/domain/usecases/check_nickname_usecase.dart';
import 'package:foresh_flutter/domain/usecases/click_marker_usecase.dart';
import 'package:foresh_flutter/domain/usecases/main_usecase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_announcement_usecaase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_country_code_usecase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_faq_usecaase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_inventory_usecase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_reward_product_detail_usecase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_reward_products_usecase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_sms_verify_code.dart';
import 'package:foresh_flutter/domain/usecases/request_reward_exchange_usecase.dart';
import 'package:foresh_flutter/domain/usecases/sign_up_usecase.dart';
import 'package:foresh_flutter/domain/usecases/sms_verify_code_confirm_usecase.dart';
import 'package:foresh_flutter/firebase_options.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/inventory/bloc/inventory.dart';
import 'package:foresh_flutter/presentation/login/phonenumber/bloc/phone_number.dart';
import 'package:foresh_flutter/presentation/main/bloc/main_bloc.dart';
import 'package:foresh_flutter/presentation/rewarddetail/bloc/reward_detail.dart';
import 'package:foresh_flutter/presentation/rewardlist/bloc/reward_list.dart';
import 'package:foresh_flutter/presentation/signup/bloc/sign_up.dart';
import 'package:foresh_flutter/presentation/support/announcement/bloc/announcement.dart';
import 'package:foresh_flutter/presentation/support/faq/bloc/faq.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_item_secure_storage/single_item_secure_storage.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/observed_storage.dart';
import 'package:single_item_storage/storage.dart';

import 'core/notification/notification_manager.dart';
import 'env.dart';
import 'presentation/login/countrycode/bloc/country_code.dart';
import 'presentation/login/smsverify/bloc/sms_verify.dart';
import 'presentation/markerhistory/bloc/marker_history_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 앱로거
  initAppLogger();

  ///  Firebase 초기화.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// 파이어 베이스 FCM
  await initFCM();

  /// 파이어베이스 analytics.
  final fortuneAnalytics = FortuneAnalytics(FirebaseAnalytics.instance);

  /// 다국어 설정.
  await EasyLocalization.ensureInitialized();

  /// 개발 환경 설정.
  await initEnvironment();

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

  /// 로컬 데이터 - Preference.
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  /// 파이어베이스 애널리틱스.
  serviceLocator.registerLazySingleton<FortuneAnalytics>(() => fortuneAnalytics);

  /// Router.
  serviceLocator.registerLazySingleton<FortuneRouter>(() => FortuneRouter()..init());

  /// 서비스 프로바이더.
  ApiServiceProvider apiProvider = ApiServiceProvider(
    baseUrl: serviceLocator<Environment>().remoteConfig.baseUrl,
    userStore: userStorage,
  );

  /// Preference & Storage.
  serviceLocator.registerLazySingleton<Storage<UserCredential>>(() => userStorage);
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  _initService(apiProvider);
  _initDataSource();
  _initRepository();
  _initBloc();
  _initUseCase();
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
_initService(ApiServiceProvider apiProvider) {
  serviceLocator

    /// normal.(인증이 필요하지 않은 서비스)
    ..registerLazySingleton<AuthHelperJwt>(() => apiProvider.getAuthHelperJwt())
    ..registerLazySingleton<NormalUserService>(() => apiProvider.getMemberNormalService())
    ..registerLazySingleton<NormalAuthService>(() => apiProvider.getAuthNormalService())

    /// abnormal.(인증이 필요한 서비스)
    ..registerLazySingleton<UserService>(() => apiProvider.getUserService())
    ..registerLazySingleton<MainService>(() => apiProvider.getMarkerService())
    ..registerLazySingleton<RewardService>(() => apiProvider.getRewardService())
    ..registerLazySingleton<CommonService>(() => apiProvider.getCommonService());
}

/// Bloc.
_initBloc() {
  serviceLocator
    ..registerFactory(
      () => PhoneNumberBloc(),
    )
    ..registerFactory(
      () => CountryCodeBloc(
        obtainCountryCodeUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SmsVerifyBloc(
        obtainSmsVerifyCodeUseCase: serviceLocator(),
        smsVerifyCodeConfirmUseCase: serviceLocator(),
        userStorage: serviceLocator(),
        fcmManager: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => SignUpBloc(
        checkNicknameUseCase: serviceLocator(),
        signUpUseCase: serviceLocator(),
        userStorage: serviceLocator(),
        fcmManager: serviceLocator(),
      ),
      dispose: (bloc) {
        FortuneLogger.debug(tag: "SignUpBloc", "close()");
        bloc.close();
      },
    )
    ..registerFactory(
      () => MainBloc(
        mainUseCase: serviceLocator(),
        clickMarkerUseCase: serviceLocator(),
        userStorage: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => MarkerHistoryBloc(),
    )
    ..registerFactory(
      () => InventoryBloc(
        obtainInventoryUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RewardListBloc(
        obtainRewardProductsUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AnnouncementBloc(
        obtainAnnouncementUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RewardDetailBloc(
        obtainRewardProductDetailUseCase: serviceLocator(),
        requestRewardExchangeUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FaqBloc(
        obtainFaqUseCase: serviceLocator(),
      ),
    );
}

/// DataSource.
_initDataSource() {
  serviceLocator
    ..registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(sharedPreferences: serviceLocator()),
    )
    ..registerLazySingleton<UserNormalDataSource>(
      () => UserNormalRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerLazySingleton<AuthNormalDataSource>(
      () => AuthNormalDataSourceImpl(serviceLocator()),
    )
    ..registerLazySingleton<MainDataSource>(
      () => MainDataSourceImpl(serviceLocator()),
    )
    ..registerLazySingleton<RewardDataSource>(
      () => RewardDataSourceImpl(serviceLocator()),
    )
    ..registerLazySingleton<CommonDataSource>(
      () => CommonDataSourceImpl(serviceLocator()),
    );
}

/// Repository.
_initRepository() {
  serviceLocator
    ..registerLazySingleton<FortuneErrorMapper>(() => FortuneErrorMapper())
    ..registerLazySingleton<UserNormalRemoteRepository>(
      () => UserNormalRepositoryImpl(
        userDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    )
    ..registerLazySingleton<AuthNormalRemoteRepository>(
      () => AuthNormalRepositoryImpl(
        authDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    )
    ..registerLazySingleton<MainRepository>(
      () => MainRepositoryImpl(
        markerRemoteDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    )
    ..registerLazySingleton<RewardRepository>(
      () => RewardRepositoryImpl(
        rewardDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    )
    ..registerLazySingleton<CommonRepository>(
      () => CommonRepositoryImpl(
        commonDataSource: serviceLocator(),
        errorMapper: serviceLocator(),
      ),
    );
}

/// UseCase.
_initUseCase() {
  serviceLocator
    ..registerLazySingleton<ObtainCountryCodeUseCase>(
      () => ObtainCountryCodeUseCase(serviceLocator()),
    )
    ..registerLazySingleton<ObtainSmsVerifyCodeUseCase>(
      () => ObtainSmsVerifyCodeUseCase(serviceLocator()),
    )
    ..registerLazySingleton<SmsVerifyCodeConfirmUseCase>(
      () => SmsVerifyCodeConfirmUseCase(serviceLocator()),
    )
    ..registerLazySingleton<CheckNicknameUseCase>(
      () => CheckNicknameUseCase(serviceLocator()),
    )
    ..registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(serviceLocator()),
    )
    ..registerLazySingleton<ClickMarkerUseCase>(
      () => ClickMarkerUseCase(serviceLocator()),
    )
    ..registerLazySingleton<MainUseCase>(
      () => MainUseCase(serviceLocator()),
    )
    ..registerLazySingleton<ObtainInventoryUseCase>(
      () => ObtainInventoryUseCase(serviceLocator()),
    )
    ..registerLazySingleton<ObtainRewardProductsUseCase>(
      () => ObtainRewardProductsUseCase(serviceLocator()),
    )
    ..registerLazySingleton<ObtainRewardProductDetailUseCase>(
      () => ObtainRewardProductDetailUseCase(serviceLocator()),
    )
    ..registerLazySingleton<RequestRewardExchangeUseCase>(
      () => RequestRewardExchangeUseCase(serviceLocator()),
    )
    ..registerLazySingleton<ObtainAnnouncementUseCase>(
      () => ObtainAnnouncementUseCase(serviceLocator()),
    )
    ..registerLazySingleton<ObtainFaqUseCase>(
      () => ObtainFaqUseCase(serviceLocator()),
    );
}
