import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_web_router.dart';
import 'package:fortune/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../agreeterms/web_agree_terms_bottom_sheet.dart';
import '../verifycode/web_verify_code_bottom_sheet.dart';
import 'bloc/web_login.dart';
import 'component/web_login_button.dart';
import 'component/web_login_email_input_field.dart';

class WebLoginPage extends StatelessWidget {
  const WebLoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<WebLoginBloc>()..add(WebLoginInit()),
      child: Scaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context),
        body: const SafeArea(
          bottom: true,
          child: _WebLoginPage(),
        ),
      ),
    );
  }
}

class _WebLoginPage extends StatefulWidget {
  const _WebLoginPage({Key? key}) : super(key: key);

  @override
  State<_WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<_WebLoginPage> {
  late WebLoginBloc _bloc;
  final router = serviceLocator<FortuneWebRouter>().router;
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<WebLoginBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<WebLoginBloc, WebLoginSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is WebLoginError) {
          dialogService.showErrorDialog(context, sideEffect.error, needToFinish: false);
        } else if (sideEffect is WebLoginShowTermsBottomSheet) {
          final result = await context.showBottomSheet(
            isDismissible: false,
            content: (context) => WebAgreeTermsBottomSheet(sideEffect.phoneNumber),
          );
          if (result != null && result) {
            _bloc.add(WebLoginRequestVerifyCode());
          }
        } else if (sideEffect is WebLoginShowVerifyCodeBottomSheet) {
          final result = await context.showBottomSheet(
            isDismissible: false,
            content: (context) => WebVerifyCodeBottomSheet(
              email: sideEffect.email,
            ),
          );
        } else if (sideEffect is WebLoginLandingRoute) {
          router.navigateTo(
            context,
            sideEffect.route,
            clearStack: true,
          );
        } else if (sideEffect is WebLoginWithdrawalUser) {
          final isReSignIn = sideEffect.isReSignIn;
          if (isReSignIn) {
            dialogService.showFortuneDialog(
              context,
              subTitle: FortuneTr.msgRevokeWithdrawal,
              dismissOnBackKeyPress: true,
              btnOkPressed: () => _bloc.add(WebLoginRequestCancelWithdrawal()),
            );
          } else {
            dialogService.showFortuneDialog(
              context,
              subTitle: FortuneTr.msgAlreadyWithdrawn,
              dismissOnBackKeyPress: true,
              btnOkPressed: () {},
            );
          }
        }
      },
      child: BlocBuilder<WebLoginBloc, WebLoginState>(
        builder: (context, state) {
          return KeyboardVisibilityBuilder(
            builder: (BuildContext context, bool isKeyboardVisible) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 28),
                            // 로그인 상태.
                            BlocBuilder<WebLoginBloc, WebLoginState>(
                              buildWhen: (previous, current) => previous.email != current.email,
                              builder: (context, state) {
                                return WebLoginEmailInputField(
                                  email: state.email,
                                  emailController: _phoneNumberController,
                                  onTextChanged: (text) => _bloc.add(WebLoginEmailInput(text)),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
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
                    child: BlocBuilder<WebLoginBloc, WebLoginState>(
                      buildWhen: (previous, current) => previous.isButtonEnabled != current.isButtonEnabled,
                      builder: (context, state) {
                        return WebLoginButton(
                          text: FortuneTr.msgVerifyYourself,
                          isKeyboardVisible: isKeyboardVisible,
                          isEnabled: state.isButtonEnabled,
                          onPressed: () {
                            _bloc.add(WebLoginBottomButtonClick());
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}