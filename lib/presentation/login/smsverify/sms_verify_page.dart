import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/permission.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/dialog/defalut_dialog.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/login/smsverify/component/sms_verfiy_bottom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/sms_verify.dart';
import 'component/text_field_pin.dart';

/// 번호 및 국가번호 정보.
class SmsVerifyArgs {
  final String phoneNumber;
  final String countryCode;

  SmsVerifyArgs({
    required this.phoneNumber,
    required this.countryCode,
  });
}

class SmsVerifyPage extends StatelessWidget {
  final String phoneNumber;
  final String countryCode;

  const SmsVerifyPage({
    Key? key,
    required this.phoneNumber,
    required this.countryCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<SmsVerifyBloc>()
        ..add(
          SmsVerifyInit(
            phoneNumber: phoneNumber,
            countryCode: countryCode,
          ),
        ),
      child: const _SmsVerifyPage(),
    );
  }
}

class _SmsVerifyPage extends StatefulWidget {
  const _SmsVerifyPage({Key? key}) : super(key: key);

  @override
  State<_SmsVerifyPage> createState() => _SmsVerifyPageState();
}

class _SmsVerifyPageState extends State<_SmsVerifyPage> with WidgetsBindingObserver {
  late TextEditingController textEditingController;
  late SmsVerifyBloc bloc;
  final router = serviceLocator<FortuneRouter>().router;
  bool _detectPermission = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    textEditingController = TextEditingController();
    bloc = BlocProvider.of<SmsVerifyBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AltSmsAutofill().unregisterListener();
    bloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        FortuneLogger.debug(" AppLifecycleState.resumed");
        PermissionStatus status = await Permission.sms.status;
        if (_detectPermission) {
          if (!status.isGranted) {
            bloc.add(
              SmsVerifyInit(
                phoneNumber: bloc.state.phoneNumber,
                countryCode: bloc.state.countryCode,
              ),
            );
            _detectPermission = false;
          } else {
            bloc.add(SmsVerifyRequestCode());
            _detectPermission = false;
          }
        }
        break;
      case AppLifecycleState.paused:
        FortuneLogger.debug("AppLifecycleState.paused");
        PermissionStatus status = await Permission.sms.status;
        if (!status.isGranted) {
          _detectPermission = true;
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<SmsVerifyBloc, SmsVerifySideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is SmsVerifyError) {
          context.handleError(sideEffect.error);
        } else if (sideEffect is SmsVerifyMovePage) {
          switch (sideEffect.page) {
            case SmsVerifyNextPage.nickName:
              _moveEnterNickNamePage();
              break;
            case SmsVerifyNextPage.navigation:
              landingToNavigationPage();
              break;
            default:
              break;
          }
        } else if (sideEffect is SmsVerifyOpenSetting) {
          context.showFortuneDialog(
            title: '권한요청',
            subTitle: 'SMS 권한이 필요합니다.',
            btnOkText: '이동',
            btnOkPressed: () => openAppSettings(),
          );
        } else if (sideEffect is SmsVerifyStartListening) {
          FortunePermissionUtil().startSmsListening(
            (verifyCode) {
              textEditingController.text = verifyCode;
              bloc.add(SmsVerifyInput(verifyCode: verifyCode, auto: true));
            },
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 100.h),
                              Text("문자로 전송된\n인증번호를 입력해주세요", style: FortuneTextStyle.headLine3()),
                              SizedBox(height: 40.h),
                              Padding(
                                padding: EdgeInsets.only(right: 120.w),
                                child: TextFieldPin(
                                  context: context,
                                  onChanged: (value) {
                                    bloc.add(SmsVerifyInput(verifyCode: value, auto: false));
                                  },
                                  textEditingController: textEditingController,
                                ),
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
                      child: BlocBuilder<SmsVerifyBloc, SmsVerifyState>(
                        builder: (context, state) {
                          return SmsVerifyBottomButton(
                            state,
                            onPress: () {
                              bloc.add(SmsVerifyBottomButtonPressed());
                            },
                            isKeyboardVisible: isKeyboardVisible,
                          );
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

  _moveEnterNickNamePage() {
    // 회원가입 할 때 사용할려고 phoneNumber와 countryCode 전달.
    // bloc은 닉네임 페이지에서 생성.
    router.navigateTo(
      context,
      Routes.putNickNameRoute,
      routeSettings: RouteSettings(
        arguments: SmsVerifyArgs(
          phoneNumber: bloc.state.phoneNumber,
          countryCode: bloc.state.countryCode,
        ),
      ),
      clearStack: true,
    );
  }

  void landingToNavigationPage() {
    // 이미 가입된 회원 + 권한이 있을 경우.> 메인페이지로 이동.
    router.navigateTo(
      context,
      Routes.mainRoute,
      clearStack: true,
    );
  }
}
