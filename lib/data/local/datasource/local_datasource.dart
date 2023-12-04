import 'package:fortune/env.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';
import 'package:single_item_storage/storage.dart';

abstract class LocalDataSource {
  Future<bool> getAllowPushAlarm();

  Future<bool> setAllowPushAlarm(bool isAllow);

  Future<int> setVerifySmsTime(int time);

  Future<int> getVerifySmsTime();

  Future<bool> getShowAd();

  Future<void> setShowAdCounter();
}

class LocalDataSourceImpl extends LocalDataSource {
  final Storage<bool> _pushAlarm = SharedPrefsStorage<bool>.primitive(itemKey: pushAlarmKey);
  final Storage<int> _verifySmsTime = SharedPrefsStorage<int>.primitive(itemKey: verifySmsTimeKey);
  final Storage<int> _adCounter = SharedPrefsStorage<int>.primitive(itemKey: adCounter);

  final FortuneRemoteConfig remoteConfig;

  static const testAccountKey = "testAccount";
  static const pushAlarmKey = "pushAlarm";
  static const verifySmsTimeKey = "verifySmsTimeKey";
  static const adCounter = "adCounter";

  final int adShowThreshold;

  LocalDataSourceImpl({
    required this.remoteConfig,
  }) : adShowThreshold = remoteConfig.adShowThreshold;

  @override
  Future<bool> getAllowPushAlarm() async {
    final isAllow = await _pushAlarm.get() ?? false;
    return isAllow;
  }

  @override
  Future<bool> setAllowPushAlarm(bool isAllow) async {
    return await _pushAlarm.save(isAllow);
  }

  @override
  Future<int> setVerifySmsTime(int time) async {
    return await _verifySmsTime.save(time);
  }

  @override
  Future<int> getVerifySmsTime() async {
    final time = await _verifySmsTime.get() ?? 0;
    return time;
  }

  @override
  Future<bool> getShowAd() async {
    final time = await _adCounter.get() ?? 0;
    return time >= adShowThreshold;
  }

  @override
  Future<void> setShowAdCounter() async {
    final time = await _adCounter.get() ?? 0;
    if (time >= adShowThreshold) {
      _adCounter.save(0);
    } else {
      _adCounter.save(time + 1);
    }
  }
}
