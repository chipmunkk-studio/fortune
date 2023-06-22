import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/core/widgets/dialog/defalut_dialog.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/mission_detail_normal.dart';
import 'component/ingredient_layout.dart';

class MissionDetailNormalPage extends StatelessWidget {
  const MissionDetailNormalPage(
    this.mission, {
    Key? key,
  }) : super(key: key);

  final MissionEntity mission;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<MissionDetailNormalBloc>()..add(MissionDetailNormalInit(mission)),
      child: FortuneScaffold(
        padding: const EdgeInsets.all(0),
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: ""),
        child: const _MissionDetailNormalPage(),
      ),
    );
  }
}

class _MissionDetailNormalPage extends StatefulWidget {
  const _MissionDetailNormalPage({Key? key}) : super(key: key);

  @override
  State<_MissionDetailNormalPage> createState() => _MissionDetailNormalPageState();
}

class _MissionDetailNormalPageState extends State<_MissionDetailNormalPage> {
  late final MissionDetailNormalBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MissionDetailNormalBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MissionDetailNormalBloc, MissionDetailNormalSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is MissionDetailNormalClearSuccess) {
          context.showFortuneDialog(
            title: '교환신청 완료',
            subTitle: '축하해요!',
            btnOkText: '확인',
            btnOkPressed: () {
              router.pop(context, true);
            },
          );
        } else if (sideEffect is MissionDetailNormalError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<MissionDetailNormalBloc, MissionDetailNormalState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            state.entity.mission.detailTitle,
                            style: FortuneTextStyle.subTitle1SemiBold(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            state.entity.mission.detailSubtitle,
                            style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark),
                          ),
                        ),
                        const SizedBox(height: 40),
                        IngredientLayout(state.entity.markers),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            state.entity.mission.detailContent,
                            style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark),
                          ),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
                child: FortuneBottomButton(
                  isEnabled: state.isEnableButton,
                  buttonText: "교환하기",
                  onPress: () => _showExchangeBottomSheet(),
                  isKeyboardVisible: false,
                ),
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
                  _bloc.add(MissionDetailNormalExchange());
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

class LayoutExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(10.0),
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: <Widget>[
        _buildGridTile(1),
        _buildGridTile(2),
        SizedBox.shrink(),
        _buildGridTile(3),
        _buildGridTile(4),
        _buildGridTile(5),
        SizedBox.shrink(),
        _buildGridTile(6),
        _buildGridTile(7),
      ],
    );
  }

  Widget _buildGridTile(int index) {
    return FractionallySizedBox(
      alignment: Alignment.center,
      widthFactor: 0.6,
      heightFactor: 0.6,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.grey,
        ),
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
