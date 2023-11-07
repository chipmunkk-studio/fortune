import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_web_router.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/core/widgets/checkbox/fortune_check_box.dart';
import 'package:fortune/di.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/web_agree_terms.dart';

class WebAgreeTermsBottomSheet extends StatelessWidget {
  final String phoneNumber;

  const WebAgreeTermsBottomSheet(
    this.phoneNumber, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<WebAgreeTermsBloc>()..add(WebAgreeTermsInit(phoneNumber)),
      child: const _WebAgreeTermsBottomSheet(),
    );
  }
}

class _WebAgreeTermsBottomSheet extends StatefulWidget {
  const _WebAgreeTermsBottomSheet({
    super.key,
  });

  @override
  State<_WebAgreeTermsBottomSheet> createState() => _WebAgreeTermsBottomSheetState();
}

class _WebAgreeTermsBottomSheetState extends State<_WebAgreeTermsBottomSheet> {
  late WebAgreeTermsBloc _bloc;
  final router = serviceLocator<FortuneWebRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<WebAgreeTermsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<WebAgreeTermsBloc, WebAgreeTermsSideEffect>(
      listener: (BuildContext context, WebAgreeTermsSideEffect sideEffect) {
        if (sideEffect is WebAgreeTermsPop) {
          router.pop(context, sideEffect.flag);
        } else if (sideEffect is WebAgreeTermsError) {
          dialogService.showAppErrorDialog(
            context,
            sideEffect.error,
            btnOkOnPress: () {
              router.pop(context, false);
            },
          );
        }
      },
      child: BlocBuilder<WebAgreeTermsBloc, WebAgreeTermsState>(
        buildWhen: (previous, current) => previous.agreeTerms != current.agreeTerms,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 24),
                  Flexible(
                    child: Text(
                      FortuneTr.msgRequireTermsUse,
                      style: FortuneTextStyle.headLine2(),
                    ),
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
                    scaleFactor: 0.9,
                    onTap: () => _bloc.add(WebAgreeTermsTermClick(item)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 24),
                        FortuneCheckBox(
                          onCheck: (isCheck) => _bloc.add(WebAgreeTermsTermClick(item)),
                          state: item.isChecked,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title,
                            style: FortuneTextStyle.body1Light(
                              color: ColorName.grey200,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => router.navigateTo(
                            context,
                            "${WebRoutes.termsDetailRoute}/${item.index}",
                          ),
                          child: Assets.icons.icArrowRight16.svg(),
                        ),
                        const SizedBox(width: 24)
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
                  text: FortuneTr.msgRequireTermsApprove,
                  isEnabled: true,
                  onPress: () => _bloc.add(WebAgreeTermsAllClick()),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
