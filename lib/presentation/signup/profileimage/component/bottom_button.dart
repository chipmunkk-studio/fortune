import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_scale_button.dart';
import 'package:foresh_flutter/presentation/signup/bloc/sign_up.dart';

class BottomButton extends StatelessWidget {
  final SignUpBloc bloc;

  const BottomButton(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 40,
      ),
      child: FortuneScaleButton(
        text: 'next'.tr(),
        isEnabled: true,
        press: () => bloc.add(SignUpRequest()),
      ),
    );
  }
}
