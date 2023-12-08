import 'package:fortune/env.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';
import 'package:single_item_storage/storage.dart';

abstract class LocalDataSource {
  Future<bool> getAllowPushAlarm();

  Future<bool> setAllowPushAlarm(bool isAllow);

  Future<int> setVerifySmsTime(int time);

  Future<int> getVerifySmsTime();

  Future<int> getRandomBoxRemainTime();

  Future<int> getRandomBoxStopTime();

  Future<bool> getShowAd();

  Future<void> setShowAdCounter();

  Future<void> setRandomBoxRemainTime(int time);

  Future<void> setRandomBoxStopTime(int time);
}

class LocalDataSourceImpl extends LocalDataSource {
  final Storage<bool> _pushAlarm = SharedPrefsStorage<bool>.primitive(itemKey: pushAlarmKey);
  final Storage<int> _verifySmsTime = SharedPrefsStorage<int>.primitive(itemKey: verifySmsTimeKey);
  final Storage<int> _adCounter = SharedPrefsStorage<int>.primitive(itemKey: adCounter);
  final Storage<int> _randomBoxRemainTime = SharedPrefsStorage<int>.primitive(itemKey: randomBoxRemainTime);
  final Storage<int> _randomBoxStopTime = SharedPrefsStorage<int>.primitive(itemKey: randomBoxStopTime);

  final FortuneRemoteConfig remoteConfig;

  static const testAccountKey = "testAccount";
  static const pushAlarmKey = "pushAlarm";
  static const verifySmsTimeKey = "verifySmsTimeKey";
  static const adCounter = "adCounter";
  static const randomBoxRemainTime = "randomBoxRemainTime";
  static const randomBoxStopTime = "randomBoxStopTime";

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

  @override
  Future<int> getRandomBoxRemainTime() async {
    final time = await _randomBoxRemainTime.get();
    return (time != null && time >= 0) ? time : remoteConfig.randomBoxTimer;
  }

  @override
  Future<void> setRandomBoxRemainTime(int time) async {
    await _randomBoxRemainTime.save(time);
  }

  @override
  Future<void> setRandomBoxStopTime(int time) async {
    await _randomBoxStopTime.save(time);
  }

  @override
  Future<int> getRandomBoxStopTime() async {
    final time = await _randomBoxStopTime.get();
    return (time != null && time >= 0) ? time : DateTime.now().millisecondsSinceEpoch;
  }
}
