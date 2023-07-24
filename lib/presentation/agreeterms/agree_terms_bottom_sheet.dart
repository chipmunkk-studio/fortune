import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_scale_button.dart';
import 'package:foresh_flutter/core/widgets/checkbox/fortune_check_box.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:foresh_flutter/presentation/agreeterms/bloc/agree_terms.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class AgreeTermsBottomSheet extends StatelessWidget {
  final String phoneNumber;

  const AgreeTermsBottomSheet(
    this.phoneNumber, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AgreeTermsBloc>()..add(AgreeTermsInit(phoneNumber)),
      child: const _AgreeTermsBottomSheet(),
    );
  }
}

class _AgreeTermsBottomSheet extends StatefulWidget {
  const _AgreeTermsBottomSheet({
    super.key,
  });

  @override
  State<_AgreeTermsBottomSheet> createState() => _AgreeTermsBottomSheetState();
}

class _AgreeTermsBottomSheetState extends State<_AgreeTermsBottomSheet> {
  late AgreeTermsBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AgreeTermsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<AgreeTermsBloc, AgreeTermsSideEffect>(
      listener: (BuildContext context, AgreeTermsSideEffect sideEffect) {
        if (sideEffect is AgreeTermsPop) {
          router.pop(context, sideEffect.flag);
        } else if (sideEffect is AgreeTermsError) {
          dialogService.showErrorDialog(
            context,
            sideEffect.error,
            btnOkOnPress: () {
              router.pop(context, false);
            },
          );
        }
      },
      child: BlocBuilder<AgreeTermsBloc, AgreeTermsState>(
        buildWhen: (previous, current) => previous.agreeTerms != current.agreeTerms,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 24),
                  Text(
                    "서비스 이용을 위해\n약관에 동의해주세요",
                    style: FortuneTextStyle.subTitle1SemiBold(),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: state.agreeTerms.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final item = state.agreeTerms[index];
                  return Bounceable(
                    onTap: () => _bloc.add(AgreeTermsTermClick(item)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 24),
                        FortuneCheckBox(
                          onCheck: (isCheck) => _bloc.add(AgreeTermsTermClick(item)),
                          state: item.isChecked,
                        ),
                        const SizedBox(width: 12),
                        Text(item.title, style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark)),
                        const Spacer(),
                        Assets.icons.icArrowRight16.svg(),
                        const SizedBox(width: 24),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(
                  right: 24,
                  left: 24,
                  bottom: 20,
                ),
                child: FortuneScaleButton(
                  text: "모두 동의하기",
                  isEnabled: true,
                  press: () => _bloc.add(AgreeTermsAllClick()),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
