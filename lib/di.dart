import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_error_mapper.dart';
import 'package:foresh_flutter/core/network/api/service/main_service.dart';
import 'package:foresh_flutter/core/network/api/service/normal/normal_auth_service.dart';
import 'package:foresh_flutter/core/network/api/service/normal/normal_user_service.dart';
import 'package:foresh_flutter/core/network/api/service/reward_service.dart';
import 'package:foresh_flutter/core/network/api/service/user_service.dart';
import 'package:foresh_flutter/core/network/api_service_provider.dart';
import 'package:foresh_flutter/core/network/auth_helper_jwt.dart';
import 'package:foresh_flutter/core/network/credential/user_credential.dart';
import 'package:foresh_flutter/core/util/analytics.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/datasources/local_datasource.dart';
import 'package:foresh_flutter/data/datasources/main_datasource.dart';
import 'package:foresh_flutter/data/datasources/reward_datasource.dart';
import 'package:foresh_flutter/data/datasources/user/auth_normal_datasource.dart';
import 'package:foresh_flutter/data/datasources/user/user_normal_datasource.dart';
import 'package:foresh_flutter/data/repositories/auth_normal_repository_impl.dart';
import 'package:foresh_flutter/data/repositories/main_repository_impl.dart';
import 'package:foresh_flutter/data/repositories/reward_repository_impl.dart';
import 'package:foresh_flutter/data/repositories/user_normal_repository_impl.dart';
import 'package:foresh_flutter/domain/repositories/auth_normal_remote_repository.dart';
import 'package:foresh_flutter/domain/repositories/marker_repository.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';
import 'package:foresh_flutter/domain/repositories/user_normal_remote_repository.dart';
import 'package:foresh_flutter/domain/usecases/check_nickname_usecase.dart';
import 'package:foresh_flutter/domain/usecases/click_marker_usecase.dart';
import 'package:foresh_flutter/domain/usecases/main_usecase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_country_code_usecase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_inventory_usecase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_reward_products_usecase.dart';
import 'package:foresh_flutter/domain/usecases/obtain_sms_verify_code.dart';
import 'package:foresh_flutter/domain/usecases/sign_up_usecase.dart';
import 'package:foresh_flutter/domain/usecases/sms_verify_code_confirm_usecase.dart';
import 'package:foresh_flutter/firebase_options.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/inventory/bloc/inventory.dart';
import 'package:foresh_flutter/presentation/login/phonenumber/bloc/phone_number.dart';
import 'package:foresh_flutter/presentation/main/bloc/main_bloc.dart';
import 'package:foresh_flutter/presentation/rewardlist/bloc/reward_list.dart';
import 'package:foresh_flutter/presentation/signup/bloc/sign_up.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_item_secure_storage/single_item_secure_storage.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/observed_storage.dart';
import 'package:single_item_storage/storage.dart';

import 'env.dart';
import 'presentation/login/countrycode/bloc/country_code.dart';
import 'presentation/login/smsverify/bloc/sms_verify.dart';
import 'presentation/markerhistory/bloc/marker_history_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///  Firebase 초기화.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// 파이어베이스 analytics.
  final fortuneAnalytics = FortuneAnalytics(FirebaseAnalytics.instance);

  /// 다국어 설정.
  await EasyLocalization.ensureInitialized();

  /// 앱로거
  initAppLogger();

  /// 개발환경설정.
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
  // normal.
  serviceLocator.registerLazySingleton<AuthHelperJwt>(() => apiProvider.getAuthHelperJwt());
  serviceLocator.registerLazySingleton<NormalUserService>(() => apiProvider.getMemberNormalService());
  serviceLocator.registerLazySingleton<NormalAuthService>(() => apiProvider.getAuthNormalService());
  // abnormal.
  serviceLocator.registerLazySingleton<UserService>(() => apiProvider.getUserService());
  serviceLocator.registerLazySingleton<MainService>(() => apiProvider.getMarkerService());
  serviceLocator.registerLazySingleton<RewardService>(() => apiProvider.getRewardService());
}

/// Bloc.
_initBloc() {
  serviceLocator.registerFactory(() => PhoneNumberBloc());
  serviceLocator.registerFactory(
    () => CountryCodeBloc(
      obtainCountryCodeUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => SmsVerifyBloc(
      obtainSmsVerifyCodeUseCase: serviceLocator(),
      smsVerifyCodeConfirmUseCase: serviceLocator(),
      userStorage: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => SignUpBloc(
      checkNicknameUseCase: serviceLocator(),
      signUpUseCase: serviceLocator(),
      userStorage: serviceLocator(),
    ),
    dispose: (bloc) {
      FortuneLogger.debug(tag: "SignUpBloc", "close()");
      bloc.close();
    },
  );

  serviceLocator.registerFactory(
    () => MainBloc(
      mainUseCase: serviceLocator(),
      clickMarkerUseCase: serviceLocator(),
      userStorage: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => MarkerHistoryBloc(),
  );

  serviceLocator.registerFactory(
    () => InventoryBloc(
      obtainInventoryUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => RewardListBloc(
      obtainRewardProductsUseCase: serviceLocator(),
    ),
  );
}

/// DataSource.
_initDataSource() {
  serviceLocator.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<UserNormalDataSource>(
    () => UserNormalRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AuthNormalDataSource>(
    () => AuthNormalDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<MainDataSource>(
    () => MainDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<RewardDataSource>(
    () => RewardDataSourceImpl(serviceLocator()),
  );
}

/// Repository.
_initRepository() {
  serviceLocator.registerLazySingleton<FortuneErrorMapper>(() => FortuneErrorMapper());
  serviceLocator.registerLazySingleton<UserNormalRemoteRepository>(
    () => UserNormalRepositoryImpl(
      userDataSource: serviceLocator(),
      errorMapper: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<AuthNormalRemoteRepository>(
    () => AuthNormalRepositoryImpl(
      authDataSource: serviceLocator(),
      errorMapper: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<MainRepository>(
    () => MainRepositoryImpl(
      markerRemoteDataSource: serviceLocator(),
      errorMapper: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<RewardRepository>(
    () => RewardRepositoryImpl(
      rewardDataSource: serviceLocator(),
      errorMapper: serviceLocator(),
    ),
  );
}

/// UseCase.
_initUseCase() {
  serviceLocator.registerLazySingleton<ObtainCountryCodeUseCase>(
    () => ObtainCountryCodeUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ObtainSmsVerifyCodeUseCase>(
    () => ObtainSmsVerifyCodeUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<SmsVerifyCodeConfirmUseCase>(
    () => SmsVerifyCodeConfirmUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<CheckNicknameUseCase>(
    () => CheckNicknameUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ClickMarkerUseCase>(
    () => ClickMarkerUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<MainUseCase>(
    () => MainUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ObtainInventoryUseCase>(
    () => ObtainInventoryUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ObtainRewardProductsUseCase>(
    () => ObtainRewardProductsUseCase(serviceLocator()),
  );
}
