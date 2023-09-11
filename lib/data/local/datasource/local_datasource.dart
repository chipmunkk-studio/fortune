import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<String> getTestAccount();

  Future<void> setTestAccount(String account);

  Future<bool> getAllowPushAlarm();

  Future<void> setAllowPushAlarm(bool isAllow);
}

class LocalDataSourceImpl extends LocalDataSource {
  final SharedPreferences sharedPreferences;

  static const testAccount = "testAccount";
  static const pushAlarm = "pushAlarm";

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String> getTestAccount() async {
    final account = sharedPreferences.getString(testAccount) ?? '';
    return account;
  }

  @override
  Future<void> setTestAccount(String account) async {
    await sharedPreferences.setString(testAccount, account);
  }

  @override
  Future<bool> getAllowPushAlarm() async {
    final isAllow = sharedPreferences.getBool(pushAlarm) ?? false;
    return isAllow;
  }

  @override
  Future<void> setAllowPushAlarm(bool isAllow) async {
    await sharedPreferences.setBool(pushAlarm, isAllow);
  }
}
