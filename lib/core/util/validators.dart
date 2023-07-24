class FortuneValidator {
  FortuneValidator._();

  static const _email = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
      r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';

  static const phoneNumber = r'^010[1-9]\d{7}$';
  static const verifyCode = r'^[0-9]{6}$';
  static const nickName = r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]';
  static const nickName2 = r'[a-z|A-Z|0-9|가-힣]';

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
    RegExp regExp = RegExp(nickName2);
    return regExp.hasMatch(value);
  }
}
