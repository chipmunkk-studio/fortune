import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/util/validators.dart';

class LoginEmailInputField extends StatelessWidget {
  const LoginEmailInputField({
    super.key,
    required TextEditingController emailController,
    required String email,
    required this.onTextChanged,
  })  : _emailController = emailController,
        _email = email;

  final TextEditingController _emailController;
  final Function1<String, void> onTextChanged;
  final String _email;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      style: FortuneTextStyle.button1Medium(),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9._@-]")),
        LengthLimitingTextInputFormatter(320),
      ],
      onChanged: onTextChanged,
      decoration: InputDecoration(
        isDense: false,
        hintText: FortuneTr.msgInputEmail,
        contentPadding: const EdgeInsets.all(16),
        counterText: "",
        hintStyle: FortuneTextStyle.subTitle2Medium(fontColor: ColorName.grey500),
        errorText: FortuneValidator.isValidEmail(_email) || _email.isEmpty ? null : FortuneTr.msgInputEmailNotValid,
        errorStyle: FortuneTextStyle.body3Light(color: ColorName.negative),
      ),
    );
  }
}
