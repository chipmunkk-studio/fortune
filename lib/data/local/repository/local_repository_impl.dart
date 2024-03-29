import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/local/datasource/local_datasource.dart';
import 'package:fortune/domain/local/local_respository.dart';

class LocalRepositoryImpl extends LocalRepository {
  final LocalDataSource localDataSource;

  LocalRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<bool> getAllowPushAlarm() async {
    try {
      final result = await localDataSource.getAllowPushAlarm();
      return result;
    } on FortuneFailureDeprecated catch (e) {
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
    } on FortuneFailureDeprecated catch (e) {
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
    } on FortuneFailureDeprecated catch (e) {
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
    } on FortuneFailureDeprecated catch (e) {
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
    } on FortuneFailureDeprecated catch (e) {
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
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<int> getGiftboxRemainTime() async {
    try {
      final result = await localDataSource.getGiftBoxRemainTime();
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<void> setGiftboxStopTime(int time) async {
    try {
      final result = await localDataSource.setGiftBoxStopTime(time);
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<void> setGiftboxRemainTime(int time) async {
    try {
      final result = await localDataSource.setGiftBoxRemainTime(time);
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<int> getGiftboxStopTime() async {
    try {
      final result = await localDataSource.getGiftBoxStopTime();
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<int> getCoinboxRemainTime() async {
    try {
      final result = await localDataSource.getCoinBoxRemainTime();
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<int> getCoinboxStopTime() async {
    try {
      final result = await localDataSource.getCoinBoxStopTime();
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<void> setCoinboxRemainTime(int time) async {
    try {
      final result = await localDataSource.setCoinBoxRemainTime(time);
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<void> setCoinboxStopTime(int time) async {
    try {
      final result = await localDataSource.setCoinBoxStopTime(time);
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }
}
