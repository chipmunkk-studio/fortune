class FortuneValidator {
  FortuneValidator._();

  static const _email = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
      r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';

  static const phoneNumber = r'^[1-9]\d{6,14}$';
  static const verifyCode = r'^[0-9]{6}$';
  static const nickName = r'^[가-힣A-Za-z0-9!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]{1,12}$';

  static bool isValidEmail(String email) {
    return RegExp(_email, caseSensitive: false).hasMatch(email);
  }

  static bool isValidPhoneNumber(String value) {
    RegExp regExp = RegExp(phoneNumber);
    return regExp.hasMatch(value);
  }

  static bool isValidVerifyCode(String value) {
    RegExp regExp = RegExp(verifyCode);
    return regExp.hasMatch(value);
  }

  static bool isValidNickName(String value) {
    RegExp regExp = RegExp(nickName);
    return regExp.hasMatch(value);
  }
}
