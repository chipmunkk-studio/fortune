import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TextFieldPin extends StatelessWidget {
  final dartz.Function1 onChanged;
  final BuildContext context;
  final TextEditingController textEditingController;

  const TextFieldPin({
    super.key,
    required this.context,
    required this.onChanged,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      textStyle: FortuneTextStyle.headLine3(fontColor: ColorName.active),
      pastedTextStyle: FortuneTextStyle.headLine3(fontColor: ColorName.active),
      length: 4,
      obscureText: false,
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        borderRadius: BorderRadius.zero,
        fieldHeight: 50,
        fieldWidth: 40,
        borderWidth: 1.5,
        fieldOuterPadding: EdgeInsets.zero,
        shape: PinCodeFieldShape.underline,
        activeColor: ColorName.primary,
        selectedColor: Colors.transparent,
        inactiveColor: ColorName.primary,
        disabledColor: Colors.transparent,
        activeFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
        inactiveFillColor: Colors.transparent,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      cursorColor: ColorName.primary,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      controller: textEditingController,
      keyboardType: TextInputType.number,
      onCompleted: (v) {},
      // onTap: () {
      //   print("Pressed");
      // },
      onChanged: onChanged,
    );
  }
}
