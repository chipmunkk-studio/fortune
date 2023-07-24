import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_scale_button.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/verify_code.dart';
import 'component/verify_code_number_input.dart';

class VerifyCodeBottomSheet extends StatelessWidget {
  const VerifyCodeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<VerifyCodeBloc>()..add(VerifyCodeInit()),
      child: const _VerifyCodeBottomSheet(),
    );
  }
}

class _VerifyCodeBottomSheet extends StatefulWidget {
  const _VerifyCodeBottomSheet({
    super.key,
  });

  @override
  State<_VerifyCodeBottomSheet> createState() => _VerifyCodeBottomSheetState();
}

class _VerifyCodeBottomSheetState extends State<_VerifyCodeBottomSheet> {
  late VerifyCodeBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;
  final TextEditingController _verifyCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<VerifyCodeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<VerifyCodeBloc, VerifyCodeSideEffect>(
      listener: (BuildContext context, VerifyCodeSideEffect sideEffect) {},
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
                        "인증번호를 입력해주세요",
                        style: FortuneTextStyle.subTitle1SemiBold(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<VerifyCodeBloc, VerifyCodeState>(
                    builder: (context, state) {
                      return VerifyCodeNumberInput(
                        verifyCode: state.verifyCode,
                        isRequestVerifyCodeEnable: state.isRequestVerifyCodeEnable,
                        verifyCodeController: _verifyCodeController,
                        onRequestClick: () {},
                        onTextChanged: (text) => _bloc.add(VerifyCodeInput(verifyCode: text)),
                      );
                    },
                  ),
                  // BlocListener<VerifyCodeBloc, VerifyCodeState>(
                  //   listenWhen: (previous, current) =>
                  //       previous.isRequestVerifyCodeEnable && !current.isRequestVerifyCodeEnable,
                  //   listener: (context, state) {
                  //     Timer.periodic(
                  //       const Duration(seconds: 1),
                  //       (timer) {
                  //         if (_bloc.state.verifyTime == 0) {
                  //           timer.cancel();
                  //         } else {
                  //           _bloc.add(LoginRequestVerifyCodeCountdown());
                  //         }
                  //       },
                  //     );
                  //   },
                  //   child: BlocBuilder<LoginBloc, LoginState>(
                  //     buildWhen: (previous, current) => previous.verifyTime != current.verifyTime,
                  //     builder: (context, state) => state.verifyTime != 0
                  //         ? () {
                  //             int min = state.verifyTime ~/ 60; // 초를 분으로 변환
                  //             int sec = state.verifyTime % 60; // 남은 초를 계산
                  //             String displayTime = "${min.toString().padLeft(2, '0')}분 ${sec.toString().padLeft(2, '0')}초";
                  //             return Text("$displayTime 뒤에 다시 인증번호 요청을 할 수 있습니다", style: FortuneTextStyle.body1Medium());
                  //           }()
                  //         : const SizedBox.shrink(),
                  //   ),
                  // ),
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
                      buildWhen: (previous, current) =>
                          previous.isRequestVerifyCodeEnable != current.isRequestVerifyCodeEnable,
                      builder: (context, state) {
                        return FortuneBottomButton(
                          isKeyboardVisible: isKeyboardVisible,
                          isEnabled: state.isRequestVerifyCodeEnable,
                          onPress: () {},
                          buttonText: '다음',
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
