import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/signup/bloc/sign_up.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../fortune_router.dart';
import 'component/nickname_input.dart';

class EnterNickNamePage extends StatelessWidget {
  final String phoneNumber;
  final String countryCode;

  const EnterNickNamePage({
    Key? key,
    required this.phoneNumber,
    required this.countryCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<SignUpBloc>()
        ..add(
          SignUpInit(
            phoneNumber,
            countryCode,
          ),
        ),
      child: const _EnterNickNamePage(),
    );
  }
}

class _EnterNickNamePage extends StatefulWidget {
  const _EnterNickNamePage({Key? key}) : super(key: key);

  @override
  State<_EnterNickNamePage> createState() => _EnterNickNamePageState();
}

class _EnterNickNamePageState extends State<_EnterNickNamePage> {
  late TextEditingController textEditingController;
  late SignUpBloc bloc;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    bloc = BlocProvider.of<SignUpBloc>(context);
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<SignUpBloc, SignUpSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is SignUpNickNameError) {
          context.handleError(sideEffect.error);
        } else if (sideEffect is SignUpMoveNext && sideEffect.page == SignUpMoveNextPage.profile) {
          router.navigateTo(
            context,
            Routes.enterProfileImageRoute,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: KeyboardVisibilityBuilder(
            builder: (BuildContext context, bool isKeyboardVisible) {
              return Container(
                padding: EdgeInsets.only(
                  top: 20.h,
                  bottom: isKeyboardVisible ? 0 : 20.h,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 100.h),
                              Text('enter_nickname'.tr(), style: FortuneTextStyle.headLine3()),
                              SizedBox(height: 40.h),
                              NickNameInput(
                                bloc,
                                textEditingController: textEditingController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      padding: EdgeInsets.only(
                        left: isKeyboardVisible ? 0 : 20.w,
                        right: isKeyboardVisible ? 0 : 20.w,
                        bottom: isKeyboardVisible ? 0 : 20.h,
                      ),
                      curve: Curves.easeInOut,
                      child: FortuneBottomButton(
                        isKeyboardVisible: isKeyboardVisible,
                        buttonText: 'next'.tr(),
                        isEnabled: true,
                        onPress: () {
                          bloc.add(SignUpCheckNickname());
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
