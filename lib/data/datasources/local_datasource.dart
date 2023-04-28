import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<bool> getIsShowWelcomeScreen();

  Future<void> setIsShowWelcomeScreen(bool isShow);
}

class LocalDataSourceImpl extends LocalDataSource {
  final SharedPreferences sharedPreferences;

  static const isShowWelcomeScreen = "isShowWelcomeScreen";

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> getIsShowWelcomeScreen() {
    final bool isShow = sharedPreferences.getBool(isShowWelcomeScreen) ?? true;
    return Future.value(isShow);
  }

  @override
  Future<void> setIsShowWelcomeScreen(bool isShow) {
    return sharedPreferences.setBool(isShowWelcomeScreen, isShow);
  }
}
