import 'package:flutter/foundation.dart';
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

  Future<int> getGiftBoxRemainTime();

  Future<int> getGiftBoxStopTime();

  Future<void> setGiftBoxRemainTime(int time);

  Future<void> setGiftBoxStopTime(int time);

  Future<void> setCoinBoxRemainTime(int time);

  Future<void> setCoinBoxStopTime(int time);

  Future<int> getCoinBoxRemainTime();

  Future<int> getCoinBoxStopTime();
}

class LocalDataSourceImpl extends LocalDataSource {
  final Storage<bool> _pushAlarm = SharedPrefsStorage<bool>.primitive(itemKey: pushAlarmKey);
  final Storage<int> _verifySmsTime = SharedPrefsStorage<int>.primitive(itemKey: verifySmsTimeKey);
  final Storage<int> _adCounter = SharedPrefsStorage<int>.primitive(itemKey: adCounter);
  final Storage<int> _giftBoxRemainTime = SharedPrefsStorage<int>.primitive(itemKey: giftBoxRemainTime);
  final Storage<int> _giftBoxStopTime = SharedPrefsStorage<int>.primitive(itemKey: giftBoxStopTime);
  final Storage<int> _coinBoxRemainTime = SharedPrefsStorage<int>.primitive(itemKey: coinBoxRemainTime);
  final Storage<int> _coinBoxStopTime = SharedPrefsStorage<int>.primitive(itemKey: coinBoxStopTime);

  final FortuneRemoteConfig remoteConfig;

  static const testAccountKey = "testAccount";
  static const pushAlarmKey = "pushAlarm";
  static const verifySmsTimeKey = "verifySmsTimeKey";
  static const adCounter = "adCounter";
  static const giftBoxRemainTime = "giftBoxRemainTime";
  static const giftBoxStopTime = "giftBoxStopTime";
  static const coinBoxRemainTime = "coinBoxRemainTime";
  static const coinBoxStopTime = "coinBoxStopTime";

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
  Future<int> getGiftBoxRemainTime() async {
    final time = await _giftBoxRemainTime.get();
    return (time != null && time >= 0)
        ? time
        : kReleaseMode
            ? remoteConfig.randomBoxTimer
            : 60;
  }

  @override
  Future<void> setGiftBoxRemainTime(int time) async {
    await _giftBoxRemainTime.save(time);
  }

  @override
  Future<void> setGiftBoxStopTime(int time) async {
    await _giftBoxStopTime.save(time);
  }

  @override
  Future<int> getGiftBoxStopTime() async {
    final time = await _giftBoxStopTime.get();
    return (time != null && time >= 0) ? time : DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<int> getCoinBoxRemainTime() async {
    final time = await _coinBoxRemainTime.get();
    return (time != null && time >= 0)
        ? time
        : kReleaseMode
            ? remoteConfig.randomBoxTimer + 600
            : 30;
  }

  @override
  Future<int> getCoinBoxStopTime() async {
    final time = await _coinBoxStopTime.get();
    return (time != null && time >= 0) ? time : DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<void> setCoinBoxRemainTime(int time) async {
    await _coinBoxRemainTime.save(time);
  }

  @override
  Future<void> setCoinBoxStopTime(int time) async {
    await _coinBoxStopTime.save(time);
  }
}
