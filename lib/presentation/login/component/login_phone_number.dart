import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/util/validators.dart';

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
        hintText: FortuneTr.msgInputPhoneNumber,
        contentPadding: const EdgeInsets.all(16),
        counterText: "",
        hintStyle: FortuneTextStyle.subTitle2Medium(fontColor: ColorName.grey500),
        errorText: FortuneValidator.isValidPhoneNumber(_phoneNumber) || _phoneNumber.isEmpty
            ? null
            : FortuneTr.msgInputPhoneNumberNotValid,
        errorStyle: FortuneTextStyle.body3Light(fontColor: ColorName.negative),
      ),
    );
  }
}
