import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/local/datasource/local_datasource.dart';
import 'package:foresh_flutter/domain/local/local_respository.dart';

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
}
