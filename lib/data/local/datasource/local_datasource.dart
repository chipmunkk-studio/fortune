import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';
import 'package:single_item_storage/storage.dart';

abstract class LocalDataSource {
  Future<String> getTestAccount();

  Future<void> setTestAccount(String account);

  Future<bool> getAllowPushAlarm();

  Future<bool> setAllowPushAlarm(bool isAllow);
}

class LocalDataSourceImpl extends LocalDataSource {
  final Storage<String> _testAccount = SharedPrefsStorage<String>.primitive(itemKey: testAccountKey);
  final Storage<bool> _pushAlarm = SharedPrefsStorage<bool>.primitive(itemKey: pushAlarmKey);

  static const testAccountKey = "testAccount";
  static const pushAlarmKey = "pushAlarm";

  LocalDataSourceImpl();

  @override
  Future<String> getTestAccount() async {
    final account = await _testAccount.get() ?? '';
    return account;
  }

  @override
  Future<void> setTestAccount(String account) async {
    await _testAccount.save(account);
  }

  @override
  Future<bool> getAllowPushAlarm() async {
    final isAllow = await _pushAlarm.get() ?? false;
    return isAllow;
  }

  @override
  Future<bool> setAllowPushAlarm(bool isAllow) async {
    return await _pushAlarm.save(isAllow);
  }
}
