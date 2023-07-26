import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/util/validators.dart';

class LoginPhoneNumber extends StatelessWidget {
  const LoginPhoneNumber({
    super.key,
    required TextEditingController phoneNumberController,
    required String phoneNumber,
    required this.onTextChanged,
  })  : _phoneNumberController = phoneNumberController,
        _phoneNumber = phoneNumber;

  final TextEditingController _phoneNumberController;
  final Function1<String, void> onTextChanged;
  final String _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      maxLength: 13,
      style: FortuneTextStyle.button1Medium(),
      controller: _phoneNumberController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      onChanged: onTextChanged,
      decoration: InputDecoration(
        isDense: false,
        hintText: "휴대폰 번호를 입력하세요",
        contentPadding: EdgeInsets.all(16),
        counterText: "",
        hintStyle: FortuneTextStyle.subTitle3Regular(fontColor: ColorName.deActive),
        errorText:
            FortuneValidator.isValidPhoneNumber(_phoneNumber) || _phoneNumber.isEmpty ? null : "올바른 휴대폰 번호가 아닙니다.",
        errorStyle: FortuneTextStyle.body3Regular(fontColor: ColorName.negative),
      ),
    );
  }
}
