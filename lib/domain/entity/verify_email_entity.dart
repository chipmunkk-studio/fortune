class VerifyEmailEntity {
  final String accessToken;
  final String refreshToken;
  final String signUpToken;

  VerifyEmailEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.signUpToken,
  });
}
