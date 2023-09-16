abstract class LocalRepository {
  // 테스트 계정 가져 오기.
  Future<String> getTestAccount();

  // 테스트 계정 저장.
  Future<void> setTestAccount(String account);

  // 푸시알람 허용 여부.
  Future<bool> getAllowPushAlarm();

  // 푸시알람 허용 여부 수정.
  Future<bool> setAllowPushAlarm(bool isAllow);

  // 마지막으로 인증번호 보낸 시간 저장.
  Future<int> setVerifySmsTime();

  // 마지막으로 인증번호 보낸 시간.
  Future<int> getVerifySmsTime();
}
