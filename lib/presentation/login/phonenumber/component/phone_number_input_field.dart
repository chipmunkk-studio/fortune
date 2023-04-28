import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/validators.dart';

import '../../../../core/widgets/textform/fortune_text_form.dart';
import '../bloc/phone_number.dart';

class PhoneNumberInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final PhoneNumberState state;
  final Function0 onSuffixIconClick;
  final Function1<String, void> onTextChanged;

  const PhoneNumberInputField(
    this.state, {
    Key? key,
    required this.textEditingController,
    required this.onSuffixIconClick,
    required this.onTextChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FortuneTextForm(
        textEditingController: textEditingController,
        suffixIcon: "assets/icons/ic_cancel_circle.svg",
        onSuffixIconClicked: () {
          textEditingController.clear();
          onSuffixIconClick();
        },
        maxLength: 12,
        onTextChanged: onTextChanged,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        hint: 'require_certify_phone_number_hint'.tr(),
        errorMessage: () {
          if (state.phoneNumber.isNotEmpty && !FortuneValidator.isValidPhoneNumber(state.phoneNumber)) {
            return 'require_certify_phone_number_error'.tr();
          } else {
            return null;
          }
        }(),
      ),
    );
  }
}
