import '../../core/util/usecase.dart';

abstract class LocalRepository {
  Future<FortuneResult<bool>> getIsShowWelcomeScreen();
  Future<FortuneResult<void>> setIsShowWelcomeScreen(bool isShow);
}