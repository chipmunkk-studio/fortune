abstract class LocalRepository {
  // 테스트 계정 가져 오기.
  Future<String> getTestAccount();

  // 테스트 계정 저장.
  Future<void> setTestAccount(String account);
}
