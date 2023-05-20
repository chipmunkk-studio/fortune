import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/core/widgets/dialog/defalut_dialog.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/rewarddetail/bloc/reward_detail.dart';
import 'package:foresh_flutter/presentation/rewarddetail/component/reward_image.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'component/need_fortune_area.dart';
import 'component/reward_notices.dart';
import 'component/reward_skeleton.dart';
import 'component/reward_title.dart';

class RewardDetailPage extends StatelessWidget {
  const RewardDetailPage(
    this.rewardId, {
    Key? key,
  }) : super(key: key);

  final int rewardId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<RewardDetailBloc>()..add(RewardDetailInit(rewardId)),
      child: FortuneScaffold(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: ""),
        child: const _RewardDetailPage(),
      ),
    );
  }
}

class _RewardDetailPage extends StatefulWidget {
  const _RewardDetailPage({Key? key}) : super(key: key);

  @override
  State<_RewardDetailPage> createState() => _RewardDetailPageState();
}

class _RewardDetailPageState extends State<_RewardDetailPage> {
  late final RewardDetailBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RewardDetailBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<RewardDetailBloc, RewardDetailSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is RewardDetailExchangeSuccess) {
          context.showFortuneDialog(
            title: '교환신청 완료',
            subTitle: '축하해요!',
            btnOkText: '확인',
            btnOkPressed: () {
              router.pop(context, true);
            },
          );
        } else if (sideEffect is RewardDetailInventoryError) {
          context.handleError(sideEffect.error);
        }
      },
      child: BlocBuilder<RewardDetailBloc, RewardDetailState>(
        builder: (context, state) {
          return Skeleton(
            isLoading: state.isLoading,
            skeleton: const RewardSkeleton(),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          RewardImage(contentImage: state.rewardImage),
                          const SizedBox(height: 36),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: RewardTitle(title: state.name),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text("교환 시 필요한 포춘",
                                style: FortuneTextStyle.body2Regular(fontColor: ColorName.activeDark)),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 36,
                            child: NeedFortuneArea(state.haveMarkers),
                          ),
                          const SizedBox(height: 36),
                          const Divider(
                            thickness: 12,
                            color: ColorName.backgroundLight,
                          ),
                          RewardNotices(state.notices),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                ColorName.background.withOpacity(1.0),
                                ColorName.background.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FortuneBottomButton(
                    isEnabled: true,
                    buttonText: "교환하기",
                    onPress: () => _showExchangeBottomSheet(),
                    isKeyboardVisible: false,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _showExchangeBottomSheet() {
    context.showFortuneBottomSheet(
      content: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "스타벅스 아이스 카페 아메리카노",
                style: FortuneTextStyle.headLine1(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "50개가 차감되며, 회원정보에 등록된 휴대폰 메세지로 모바일 상품권이 발송됩니다. 지금받으시겠습니까?",
                textAlign: TextAlign.center,
                style: FortuneTextStyle.body2Regular(),
              ),
              const SizedBox(height: 16),
              FortuneBottomButton(
                isEnabled: true,
                onPress: () {
                  router.pop(context);
                  _bloc.add(RewardDetailExchange());
                },
                buttonText: "교환",
                isKeyboardVisible: false,
              ),
            ],
          ),
        );
      },
    );
  }
}
