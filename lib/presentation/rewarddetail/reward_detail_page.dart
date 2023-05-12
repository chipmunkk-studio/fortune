import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/snackbar.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/rewarddetail/bloc/reward_detail.dart';
import 'package:foresh_flutter/presentation/rewarddetail/component/reward_image.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'component/need_fortune_area.dart';
import 'component/reward_notices.dart';
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
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0),
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
          context.showSnackBar("상품 교환 요청 성공.");
        }
      },
      child: Column(
        children: [
          BlocBuilder<RewardDetailBloc, RewardDetailState>(
            builder: (context, state) {
              return Expanded(
                child: Stack(
                  children: [
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        RewardImage(contentImage: state.rewardImage),
                        SizedBox(height: 36.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: RewardTitle(title: state.name),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text("교환 시 필요한 포춘",
                              style: FortuneTextStyle.body2Regular(fontColor: ColorName.activeDark)),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 36.h,
                          child: NeedFortuneArea(state.haveMarkers),
                        ),
                        SizedBox(height: 36.h),
                        Divider(
                          thickness: 12.h,
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
                        height: 50.h,
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
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
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
  }

  _showExchangeBottomSheet() {
    context.showFortuneBottomSheet(
      content: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "스타벅스 아이스 카페 아메리카노",
                style: FortuneTextStyle.headLine1(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                "50개가 차감되며, 회원정보에 등록된 휴대폰 메세지로 모바일 상품권이 발송됩니다. 지금받으시겠습니까?",
                textAlign: TextAlign.center,
                style: FortuneTextStyle.body2Regular(),
              ),
              SizedBox(height: 16.h),
              FortuneBottomButton(
                isEnabled: true,
                onPress: () => _bloc.add(RewardDetailExchange()),
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
