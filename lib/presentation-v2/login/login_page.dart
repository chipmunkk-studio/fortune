import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:fortune/core/widgets/button/fortune_text_button.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation-v2/agreeterms/agree_terms_bottom_sheet.dart';
import 'package:fortune/presentation-v2/verifycode/verify_code_bottom_sheet.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/login.dart';
import 'component/login_bottom_button.dart';
import 'component/login_email_input_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<LoginBloc>()..add(LoginInit()),
      child: const _LoginPage(),
    );
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage();

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  late LoginBloc _bloc;
  final router = serviceLocator<FortuneAppRouter>().router;
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<LoginBloc, LoginSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is LoginError) {
          dialogService2.showAppErrorDialog(context, sideEffect.error, needToFinish: false);
        } else if (sideEffect is LoginShowTermsBottomSheet) {
          final result = await context.showBottomSheet(
            isDismissible: false,
            content: (context) => AgreeTermsBottomSheet(sideEffect.phoneNumber),
          );
          if (result != null && result) {
            _bloc.add(LoginRequestVerifyCode());
          }
        } else if (sideEffect is LoginShowVerifyCodeBottomSheet) {
          await context.showBottomSheet(
            isDismissible: false,
            content: (context) => VerifyCodeBottomSheet(email: sideEffect.email),
          );
        } else if (sideEffect is LoginLandingRoute) {
          router.navigateTo(
            context,
            sideEffect.route,
            clearStack: true,
          );
        } else if (sideEffect is LoginWithdrawalUser) {
          dialogService.showFortuneDialog(
            context,
            subTitle: FortuneTr.msgAlreadyWithdrawn,
            dismissOnBackKeyPress: true,
            btnOkPressed: () {},
          );
        }
      },
      child: KeyboardVisibilityBuilder(
        builder: (BuildContext context, bool isKeyboardVisible) {
          return BlocBuilder<LoginBloc, LoginState>(
            buildWhen: (previous, current) => previous.isLoading != current.isLoading,
            builder: (context, state) {
              return Stack(
                children: [
                  Scaffold(
                    appBar: FortuneCustomAppBar.leadingAppBar(
                      context,
                      onPressed: () {
                        // 로그인 화면에서는 뒤로가기 동작 없음.
                      },
                    ),
                    body: SafeArea(
                      bottom: true,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 28),
                                    // 상단 타이틀.
                                    BlocBuilder<LoginBloc, LoginState>(
                                      buildWhen: (previous, current) => previous.guideTitle != current.guideTitle,
                                      builder: (context, state) {
                                        return Text(state.guideTitle, style: FortuneTextStyle.headLine1(height: 1.3));
                                      },
                                    ),
                                    const SizedBox(height: 40),
                                    // 로그인 상태.
                                    BlocBuilder<LoginBloc, LoginState>(
                                      buildWhen: (previous, current) => previous.email != current.email,
                                      builder: (context, state) {
                                        return LoginEmailInputField(
                                          email: state.email,
                                          emailController: _phoneNumberController,
                                          onTextChanged: (text) => _bloc.add(LoginEmailInput(text)),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    if (!kReleaseMode) buildDebugRow(context)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            padding: EdgeInsets.only(
                              left: isKeyboardVisible ? 0 : 20,
                              right: isKeyboardVisible ? 0 : 20,
                              bottom: isKeyboardVisible ? 0 : 20,
                            ),
                            curve: Curves.easeInOut,
                            child: BlocBuilder<LoginBloc, LoginState>(
                              buildWhen: (previous, current) => previous.isButtonEnabled != current.isButtonEnabled,
                              builder: (context, state) {
                                return LoginBottomButton(
                                  text: FortuneTr.msgVerifyYourself,
                                  isKeyboardVisible: isKeyboardVisible,
                                  isEnabled: state.isButtonEnabled,
                                  onPressed: () {
                                    _bloc.add(LoginBottomButtonClick());
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.isLoading) ...[
                    ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.5)),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  Row buildDebugRow(BuildContext context) {
    return Row(
      children: [
        FortuneTextButton(
          onPress: () {
            context.showBottomSheet(
              isDismissible: false,
              content: (context) => const AgreeTermsBottomSheet(''),
            );
          },
          text: '약관 동의 바텀시트',
        ),
        const SizedBox(width: 12),
        FortuneTextButton(
          onPress: () {
            context.showBottomSheet(
              isDismissible: false,
              content: (context) => const VerifyCodeBottomSheet(email: ''),
            );
          },
          text: '인증번호 확인 바텀시트',
        ),
      ],
    );
  }
}
