import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/verifycode/verify_code_bottom_sheet.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../agreeterms/agree_terms_bottom_sheet.dart';
import 'bloc/login.dart';
import 'component/login_bottom_button.dart';
import 'component/login_phone_number.dart';

class LoginPage extends StatelessWidget {
  final LoginUserState loginState;

  const LoginPage(
    this.loginState, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<LoginBloc>()..add(LoginInit(loginState)),
      child: Scaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context),
        body: const SafeArea(
          bottom: true,
          child: _LoginPage(),
        ),
      ),
    );
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({Key? key}) : super(key: key);

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  late LoginBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('로그인 화면');
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
          dialogService.showErrorDialog(context, sideEffect.error, needToFinish: false);
        } else if (sideEffect is LoginShowTermsBottomSheet) {
          final result = await context.showFortuneBottomSheet(
            isDismissible: false,
            content: (context) => AgreeTermsBottomSheet(sideEffect.phoneNumber),
          );
          if (result) {
            _bloc.add(LoginRequestVerifyCode());
          }
        } else if (sideEffect is LoginShowVerifyCodeBottomSheet) {
          final result = await context.showFortuneBottomSheet(
            isDismissible: false,
            content: (context) => VerifyCodeBottomSheet(sideEffect.convertedPhoneNumber),
          );
        }
      },
      child: KeyboardVisibilityBuilder(
        builder: (BuildContext context, bool isKeyboardVisible) {
          return Column(
            children: <Widget>[
              Expanded(
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
                          return Text(state.guideTitle, style: FortuneTextStyle.headLine3());
                        },
                      ),
                      const SizedBox(height: 20),
                      // 로그인 상태.
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) => previous.phoneNumber != current.phoneNumber,
                        builder: (context, state) {
                          return LoginPhoneNumber(
                            phoneNumber: state.phoneNumber,
                            phoneNumberController: _phoneNumberController,
                            onTextChanged: (text) => _bloc.add(LoginPhoneNumberInput(text)),
                          );
                        },
                      ),
                    ],
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
                      text: '본인 인증하기',
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
          );
        },
      ),
    );
  }
}
