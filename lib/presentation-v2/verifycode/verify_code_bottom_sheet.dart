import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_bottom_button.dart';
import 'package:fortune/core/widgets/button/fortune_text_button.dart';
import 'package:fortune/di.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/verify_code.dart';
import 'component/verify_code_number_input.dart';

class VerifyCodeBottomSheet extends StatelessWidget {
  final String email;

  const VerifyCodeBottomSheet({
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<VerifyCodeBloc>()
        ..add(
          VerifyCodeInit(email: email),
        ),
      child: const _VerifyCodeBottomSheet(),
    );
  }
}

class _VerifyCodeBottomSheet extends StatefulWidget {
  const _VerifyCodeBottomSheet();

  @override
  State<_VerifyCodeBottomSheet> createState() => _VerifyCodeBottomSheetState();
}

class _VerifyCodeBottomSheetState extends State<_VerifyCodeBottomSheet> {
  late VerifyCodeBloc _bloc;
  final router = serviceLocator<FortuneAppRouter>().router;
  final TextEditingController _verifyCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<VerifyCodeBloc>(context);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<VerifyCodeBloc, VerifyCodeSideEffect>(
      listener: (BuildContext context, VerifyCodeSideEffect sideEffect) {
        if (sideEffect is VerifyCodeError) {
          dialogService2.showAppErrorDialog(
            context,
            sideEffect.error,
            needToFinish: false,
          );
        } else if (sideEffect is VerifyCodeLandingRoute) {
          router.navigateTo(
            context,
            sideEffect.landingRoute,
            clearStack: sideEffect.landingRoute == AppRoutes.mainRoute,
          );
        }
      },
      child: BlocBuilder<VerifyCodeBloc, VerifyCodeState>(
        buildWhen: (previous, current) => previous.verifyCode != current.verifyCode,
        builder: (context, state) {
          return KeyboardVisibilityBuilder(
            builder: (BuildContext context, bool isKeyboardVisible) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 24),
                      Text(
                        FortuneTr.msgRequireVerifyCodeInput,
                        style: FortuneTextStyle.headLine2(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  VerifyCodeNumberInput(
                    verifyCode: state.verifyCode,
                    verifyCodeController: _verifyCodeController,
                    onTextChanged: (text) => _bloc.add(VerifyCodeInput(verifyCode: text)),
                    onVerifyTimeCountdown: () {
                      _bloc.add(VerifyCodeCountdown());
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<VerifyCodeBloc, VerifyCodeState>(
                    buildWhen: (previous, current) =>
                        previous.isRequestVerifyCodeEnable != current.isRequestVerifyCodeEnable,
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FortuneTextButton(
                          onPress:
                              state.isRequestVerifyCodeEnable ? () => _bloc.add(VerifyCodeRequestVerifyCode()) : null,
                          text: FortuneTr.msgRequireVerifyCodeReceive,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: EdgeInsets.only(
                      left: isKeyboardVisible ? 0 : 20,
                      right: isKeyboardVisible ? 0 : 20,
                      bottom: isKeyboardVisible ? 0 : 20,
                    ),
                    curve: Curves.easeInOut,
                    child: BlocBuilder<VerifyCodeBloc, VerifyCodeState>(
                      buildWhen: (previous, current) => previous.isConfirmEnable != current.isConfirmEnable,
                      builder: (context, state) {
                        return FortuneBottomButton(
                          isKeyboardVisible: isKeyboardVisible,
                          isEnabled: state.isConfirmEnable && !state.isLoginProcessing,
                          onPress: () => _bloc.add(VerifyConfirm()),
                          text: FortuneTr.confirm,
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
