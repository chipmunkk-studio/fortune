import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/presentation/signup/bloc/sign_up.dart';

import '../../../../core/widgets/textform/fortune_text_form.dart';

class NickNameInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final SignUpBloc bloc;

  const NickNameInput(
    this.bloc, {
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: FortuneTextForm(
            textEditingController: textEditingController,
            suffixIcon: Assets.icons.icCancelCircle.keyName,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(FortuneValidator.nickName))],
            onSuffixIconClicked: () {
              textEditingController.clear();
              bloc.add(SignUpNicknameClear());
            },
            onTextChanged: (text) => bloc.add(SignUpNickNameInput(text)),
            maxLength: 12,
            keyboardType: TextInputType.text,
            hint: 'enter_nickname_hint'.tr(),
            errorMessage: () {
              final currentNickName = state.signUpForm.nickname;
              if (currentNickName.isNotEmpty && !FortuneValidator.isValidNickName(currentNickName)) {
                return 'require_input_nickname_error'.tr();
              } else {
                return null;
              }
            }(),
          ),
        );
      },
    );
  }
}
