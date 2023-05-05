import 'package:easy_localization/easy_localization.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/login/smsverify/sms_verify_page.dart';

import '../bloc/phone_number.dart';

class PhoneNumberBottomButton extends StatelessWidget {
  final bool isKeyboardVisible;
  final FluroRouter router;
  final PhoneNumberState state;

  const PhoneNumberBottomButton(
    this.isKeyboardVisible,
    this.router,
    this.state, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FortuneBottomButton(
      isKeyboardVisible: isKeyboardVisible,
      isEnabled: state.isButtonEnabled,
      buttonText: 'next'.tr(),
      onPress: () {
        router.navigateTo(
          context,
          Routes.smsCertifyRoute,
          routeSettings: RouteSettings(
            arguments: SmsVerifyArgs(
              phoneNumber: state.phoneNumber,
              countryCode: state.countryCode,
            ),
          ),
        );
      },
    );
  }
}
