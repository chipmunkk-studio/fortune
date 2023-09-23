import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/image_picker.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/core/widgets/textform/fortune_text_form.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation/fortune_router.dart';
import 'package:fortune/presentation/nickname/component/profile_image.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/nick_name.dart';

class NickNamePage extends StatelessWidget {
  const NickNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<NickNameBloc>()..add(NickNameInit()),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: FortuneTr.myInfoModify),
        child: const _NickNamePage(),
      ),
    );
  }
}

class _NickNamePage extends StatefulWidget {
  const _NickNamePage({Key? key}) : super(key: key);

  @override
  State<_NickNamePage> createState() => _NickNamePageState();
}

class _NickNamePageState extends State<_NickNamePage> {
  final _router = serviceLocator<FortuneRouter>().router;
  late NickNameBloc _bloc;
  final _nickNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<NickNameBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<NickNameBloc, NickNameSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is NickNameError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        } else if (sideEffect is NickNameUserInfoInit) {
          _nickNameController.text = sideEffect.user.nickname;
          _phoneNumberController.text = sideEffect.user.phone;
        }
      },
      child: BlocBuilder<NickNameBloc, NickNameState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: ProfileImage(
                  onProfileTap: () => FortuneImagePicker().loadImagePicker(
                    (path) => _bloc.add(NickNameUpdateProfile(path)),
                  ),
                  profileUrl: state.userEntity.profileImage,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  FortuneTr.nickname,
                  style: FortuneTextStyle.body3Light(color: ColorName.grey400),
                ),
              ),
              const SizedBox(height: 8),
              FortuneTextForm(
                suffixIcon: Assets.icons.icCancelCircle.path,
                textEditingController: _nickNameController,
                maxLength: 12,
                onTextChanged: (text) => _bloc.add(NickNameTextInput(text)),
                onSuffixIconClicked: () {
                  _bloc.add(NickNameTextInput(''));
                  _nickNameController.clear();
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  FortuneTr.phoneNumber,
                  style: FortuneTextStyle.body3Light(color: ColorName.grey400),
                ),
              ),
              const SizedBox(height: 8),
              FortuneTextForm(
                readOnly: true,
                suffixIcon: Assets.icons.icCancelCircle.path,
                textEditingController: _phoneNumberController,
                maxLength: 12,
                onTextChanged: (String a) {},
              ),
              const Spacer(),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Bounceable(
                      onTap: () {
                        // todo
                      },
                      child: Text(
                        FortuneTr.logout,
                        style: FortuneTextStyle.body3Light(color: ColorName.grey400),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const VerticalDivider(
                      thickness: 1,
                      width: 1,
                      color: ColorName.grey500,
                    ),
                    const SizedBox(width: 12),
                    Bounceable(
                      onTap: () {
                        // todo
                      },
                      child: Text(
                        FortuneTr.withdrawal,
                        style: FortuneTextStyle.body3Light(color: ColorName.grey400),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<NickNameBloc, NickNameState>(
                buildWhen: (previous, current) => previous.isButtonEnabled != current.isButtonEnabled,
                builder: (context, state) {
                  return FortuneScaleButton(
                    isEnabled: state.isButtonEnabled,
                    text: FortuneTr.save,
                    onPress: () {
                      // todo
                    },
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
