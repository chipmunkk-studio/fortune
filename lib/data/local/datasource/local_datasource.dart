import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<String> getTestAccount();

  Future<void> setTestAccount(String account);
}

class LocalDataSourceImpl extends LocalDataSource {
  final SharedPreferences sharedPreferences;

  static const testAccount = "testAccount";

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
}
