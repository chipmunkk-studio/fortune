import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/local/datasource/local_datasource.dart';
import 'package:fortune/domain/local/local_respository.dart';

class LocalRepositoryImpl extends LocalRepository {
  final LocalDataSource localDataSource;

  LocalRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<String> getTestAccount() async {
    try {
      final result = await localDataSource.getTestAccount();
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '테스트 계정을 찾을 수 없습니다',
      );
    }
  }

  @override
  Future<void> setTestAccount(String account) async {
    try {
      final result = await localDataSource.setTestAccount(account);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '테스트 계정을 설정 할 수 없습니다',
      );
    }
  }

  @override
  Future<bool> getAllowPushAlarm() async {
    try {
      final result = await localDataSource.getAllowPushAlarm();
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '푸시 알람을 설정할 수 없습니다',
      );
    }
  }

  @override
  Future<bool> setAllowPushAlarm(bool isAllow) async {
    try {
      final result = await localDataSource.setAllowPushAlarm(isAllow);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '테스트 계정을 설정 할 수 없습니다',
      );
    }
  }

  @override
  Future<int> setVerifySmsTime() async {
    try {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final result = await localDataSource.setVerifySmsTime(currentTime);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<int> getVerifySmsTime() async {
    try {
      final result = await localDataSource.getVerifySmsTime();
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<bool> getShowAd() async {
    try {
      final result = await localDataSource.getShowAd();
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<void> setShowAdCounter() async {
    try {
      final result = await localDataSource.setShowAdCounter();
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }
}
