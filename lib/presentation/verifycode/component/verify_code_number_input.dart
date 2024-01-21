import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/presentation/verifycode/bloc/verify_code.dart';

class VerifyCodeNumberInput extends StatefulWidget {
  const VerifyCodeNumberInput({
    super.key,
    required String verifyCode,
    required TextEditingController verifyCodeController,
    required this.onTextChanged,
    required this.onVerifyTimeCountdown,
  })  : _verifyCodeController = verifyCodeController,
        _verifyCode = verifyCode;

  final dartz.Function1<String, void> onTextChanged;
  final dartz.Function0<void> onVerifyTimeCountdown;
  final TextEditingController _verifyCodeController;
  final String _verifyCode;

  @override
  State<VerifyCodeNumberInput> createState() => _VerifyCodeNumberInputState();
}

class _VerifyCodeNumberInputState extends State<VerifyCodeNumberInput> {
  Timer? timer;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              BlocBuilder<VerifyCodeBloc, VerifyCodeState>(
                buildWhen: (previous, current) => previous.phoneNumber != current.phoneNumber,
                builder: (context, state) {
                  return TextFormField(
                    autofocus: true,
                    style: FortuneTextStyle.button1Medium(),
                    controller: widget._verifyCodeController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    onChanged: widget.onTextChanged,
                    decoration: InputDecoration(
                      isDense: false,
                      hintText: FortuneTr.msgRequireVerifySixNumber,
                      contentPadding: const EdgeInsets.all(16),
                      counterText: "",
                      hintStyle: FortuneTextStyle.button1Medium(color: ColorName.grey700),
                      errorText: FortuneValidator.isValidVerifyCode(widget._verifyCode) || widget._verifyCode.isEmpty
                          ? null
                          : FortuneTr.msgRequireVerifySixNumberContent,
                      errorStyle: FortuneTextStyle.body3Regular(color: ColorName.negative),
                    ),
                  );
                },
              ),
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: BlocConsumer<VerifyCodeBloc, VerifyCodeState>(
                  listenWhen: (previous, current) =>
                      current.isRequestVerifyCodeEnable != previous.isRequestVerifyCodeEnable,
                  listener: (context, state) {
                    timer?.cancel();
                    timer = Timer.periodic(
                      const Duration(seconds: 1),
                      (timer) {
                        if (state.isRequestVerifyCodeEnable) {
                          // 인증번호 요청이 가능한 상태라면 타이머를 캔슬함
                          timer.cancel();
                        } else {
                          widget.onVerifyTimeCountdown();
                        }
                      },
                    );
                  },
                  buildWhen: (previous, current) => previous.verifyTime != current.verifyTime,
                  builder: (BuildContext context, VerifyCodeState state) {
                    return Container(
                      alignment: Alignment.center,
                      child: state.verifyTime != 0
                          ? () {
                              int min = state.verifyTime ~/ 60; // 초를 분으로 변환
                              int sec = state.verifyTime % 60; // 남은 초를 계산
                              String displayTime =
                                  "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
                              return Text(
                                state.verifyTime != 180 ? displayTime : '',
                                style: FortuneTextStyle.body2Regular(
                                  color: ColorName.grey200,
                                ),
                              );
                            }()
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
