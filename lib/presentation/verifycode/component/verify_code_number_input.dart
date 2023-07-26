import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/presentation/verifycode/bloc/verify_code.dart';

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
                      hintText: "6자리 숫자 ",
                      contentPadding: const EdgeInsets.all(16),
                      counterText: "",
                      hintStyle: FortuneTextStyle.button1Medium(fontColor: ColorName.deActive),
                      errorText: FortuneValidator.isValidVerifyCode(widget._verifyCode) || widget._verifyCode.isEmpty
                          ? null
                          : "인증번호는 숫자 6자리입니다.",
                      errorStyle: FortuneTextStyle.body3Regular(fontColor: ColorName.negative),
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
                    FortuneLogger.info("listener: ${state.verifyTime}");
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
                              FortuneLogger.info("builder: ${state.verifyTime}");
                              int min = state.verifyTime ~/ 60; // 초를 분으로 변환
                              int sec = state.verifyTime % 60; // 남은 초를 계산
                              String displayTime =
                                  "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
                              return Text(
                                displayTime,
                                style: FortuneTextStyle.body2Regular(
                                  fontColor: ColorName.activeDark,
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
