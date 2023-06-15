import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/core/widgets/dialog/defalut_dialog.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/mission_detail.dart';

class MissionDetailPage extends StatelessWidget {
  const MissionDetailPage(
    this.missionId, {
    Key? key,
  }) : super(key: key);

  final int missionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<MissionDetailBloc>()..add(MissionDetailInit(missionId)),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: ""),
        child: const _MissionDetailPage(),
      ),
    );
  }
}

class _MissionDetailPage extends StatefulWidget {
  const _MissionDetailPage({Key? key}) : super(key: key);

  @override
  State<_MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<_MissionDetailPage> {
  late final MissionDetailBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MissionDetailBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MissionDetailBloc, MissionDetailSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is MissionClearSuccess) {
          context.showFortuneDialog(
            title: '교환신청 완료',
            subTitle: '축하해요!',
            btnOkText: '확인',
            btnOkPressed: () {
              router.pop(context, true);
            },
          );
        } else if (sideEffect is MissionDetailError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<MissionDetailBloc, MissionDetailState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Text(
                          "메인타이틀을 입력하세요",
                          style: FortuneTextStyle.subTitle1SemiBold(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "서브타이틀을 입력하세요",
                          style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark),
                        ),
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
              FortuneBottomButton(
                isEnabled: state.isEnableButton,
                buttonText: "교환하기",
                onPress: () => _showExchangeBottomSheet(),
                isKeyboardVisible: false,
              ),
            ],
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
                  _bloc.add(MissionDetailExchange());
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
