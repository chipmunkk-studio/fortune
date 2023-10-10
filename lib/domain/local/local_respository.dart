abstract class LocalRepository {
  // 푸시알람 허용 여부.
  Future<bool> getAllowPushAlarm();

  // 푸시알람 허용 여부 수정.
  Future<bool> setAllowPushAlarm(bool isAllow);

  // 마지막으로 인증번호 보낸 시간 저장.
  Future<int> setVerifySmsTime();

  // 마지막으로 인증번호 보낸 시간.
  Future<int> getVerifySmsTime();

  // 3번당 광고 보여줌.
  Future<bool> getShowAd();

  // 광고 노출 횟수 카운터
  Future<void> setShowAdCounter();
}
