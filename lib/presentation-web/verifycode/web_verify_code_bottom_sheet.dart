import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_web_router.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_bottom_button.dart';
import 'package:fortune/core/widgets/button/fortune_text_button.dart';
import 'package:fortune/di.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/web_verify_code.dart';
import 'component/web_verify_code_number_input.dart';

class WebVerifyCodeBottomSheet extends StatelessWidget {
  final String email;
  final bool isRetire;

  const WebVerifyCodeBottomSheet({
    required this.email,
    this.isRetire = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<WebVerifyCodeBloc>()
        ..add(
          WebVerifyCodeInit(
            email: email,
            isRetire: isRetire,
          ),
        ),
      child: const _WebVerifyCodeBottomSheet(),
    );
  }
}

class _WebVerifyCodeBottomSheet extends StatefulWidget {
  const _WebVerifyCodeBottomSheet();

  @override
  State<_WebVerifyCodeBottomSheet> createState() => _WebVerifyCodeBottomSheetState();
}

class _WebVerifyCodeBottomSheetState extends State<_WebVerifyCodeBottomSheet> {
  late WebVerifyCodeBloc _bloc;
  final router = serviceLocator<FortuneWebRouter>().router;
  final TextEditingController _verifyCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<WebVerifyCodeBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<WebVerifyCodeBloc, WebVerifyCodeSideEffect>(
      listener: (BuildContext context, WebVerifyCodeSideEffect sideEffect) {
        if (sideEffect is WebVerifyCodeError) {
          dialogService.showWebErrorDialog(
            context,
            sideEffect.error,
            needToFinish: false,
          );
        } else if (sideEffect is WebVerifyCodeLandingRoute) {
          router.navigateTo(
            context,
            sideEffect.landingRoute,
            clearStack: sideEffect.landingRoute == WebRoutes.mainRoute,
          );
        } else if (sideEffect is WebVerifyCodeRetireSuccess) {
          dialogService.showFortuneDialog(
            context,
            subTitle: FortuneTr.msgWithdrawalComplete,
            dismissOnBackKeyPress: true,
            btnOkPressed: () {},
          );
        }
      },
      child: BlocBuilder<WebVerifyCodeBloc, WebVerifyCodeState>(
        buildWhen: (previous, current) => previous.verifyCode != current.verifyCode,
        builder: (context, state) {
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
              WebVerifyCodeNumberInput(
                verifyCode: state.verifyCode,
                verifyCodeController: _verifyCodeController,
                onTextChanged: (text) => _bloc.add(WebVerifyCodeInput(verifyCode: text)),
                onVerifyTimeCountdown: () {
                  _bloc.add(WebVerifyCodeCountdown());
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<WebVerifyCodeBloc, WebVerifyCodeState>(
                buildWhen: (previous, current) =>
                    previous.isRequestVerifyCodeEnable != current.isRequestVerifyCodeEnable,
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FortuneTextButton(
                      onPress:
                          state.isRequestVerifyCodeEnable ? () => _bloc.add(WebVerifyCodeRequestVerifyCode()) : null,
                      text: FortuneTr.msgRequireVerifyCodeReceive,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<WebVerifyCodeBloc, WebVerifyCodeState>(
                buildWhen: (previous, current) => previous.isConfirmEnable != current.isConfirmEnable,
                builder: (context, state) {
                  return FortuneBottomButton(
                    isKeyboardVisible: true,
                    isEnabled: state.isConfirmEnable && !state.isLoginProcessing,
                    onPress: () => _bloc.add(WebVerifyConfirm()),
                    text: FortuneTr.confirm,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
