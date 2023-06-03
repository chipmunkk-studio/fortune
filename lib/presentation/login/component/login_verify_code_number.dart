import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_text_button.dart';

class LoginVerifyCodeNumber extends StatelessWidget {
  const LoginVerifyCodeNumber({
    super.key,
    required String verifyCode,
    required bool isRequestVerifyCodeEnable,
    required TextEditingController verifyCodeController,
    required this.onRequestClick,
    required this.onTextChanged,
  })  : _verifyCodeController = verifyCodeController,
        _isRequestVerifyCodeEnable = isRequestVerifyCodeEnable,
        _verifyCode = verifyCode;

  final Function0 onRequestClick;
  final Function1<String, void> onTextChanged;
  final TextEditingController _verifyCodeController;
  final String _verifyCode;
  final bool _isRequestVerifyCodeEnable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: TextFormField(
              autofocus: true,
              style: FortuneTextStyle.button1Medium(),
              controller: _verifyCodeController,
              onChanged: onTextChanged,
              decoration: InputDecoration(
                isDense: false,
                hintText: "인증번호를 입력하세요",
                contentPadding: EdgeInsets.all(16),
                counterText: "",
                hintStyle: FortuneTextStyle.subTitle3Regular(fontColor: ColorName.deActive),
                errorText:
                    FortuneValidator.isValidVerifyCode(_verifyCode) || _verifyCode.isEmpty ? null : "인증번호는 숫자 6자리입니다.",
                errorStyle: FortuneTextStyle.body3Regular(fontColor: ColorName.negative),
              ),
            ),
          ),
          SizedBox(width: 16),
          FortuneTextButton(
            onPress: _isRequestVerifyCodeEnable ? () => onRequestClick() : null,
            text: '인증번호 요청',
          ),
        ],
      ),
    );
  }
}
