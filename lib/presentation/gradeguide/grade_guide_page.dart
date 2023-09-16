import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_grade_entity.dart';
import 'package:foresh_flutter/presentation/gradeguide/bloc/grade_guide.dart';
import 'package:foresh_flutter/presentation/gradeguide/component/bottom_grade_area.dart';
import 'package:foresh_flutter/presentation/gradeguide/component/item_grade.dart';
import 'package:foresh_flutter/presentation/gradeguide/component/middle_percentage.dart';
import 'package:foresh_flutter/presentation/gradeguide/component/top_grade_area.dart';

class GradeGuidePage extends StatelessWidget {
  const GradeGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "등급 안내"),
      child: BlocProvider(
        create: (_) => serviceLocator<GradeGuideBloc>()..add(GradeGuideInit()),
        child: const _GradeGuidePage(),
      ),
    );
  }
}

class _GradeGuidePage extends StatefulWidget {
  const _GradeGuidePage({Key? key}) : super(key: key);

  @override
  State<_GradeGuidePage> createState() => _GradeGuidePageState();
}

class _GradeGuidePageState extends State<_GradeGuidePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradeGuideBloc, GradeGuideState>(
      builder: (context, state) {
        return Stack(
          children: [
            AnimationList(
              physics: const BouncingScrollPhysics(),
              duration: 1500,
              reBounceDepth: 10,
              children: [
                TopGradeArea(
                  grade: state.user.grade.name,
                ),
                const SizedBox(height: 24),
                MiddlePercentage(
                  percent: state.user.nextLevelInfo.progressToNextLevelPercentage,
                ),
                const SizedBox(height: 12),
                BottomGradeArea(
                  target: getNextGrade(state.user.grade).name,
                  remainCount: state.user.nextLevelInfo.nextLevelMarkerCount.toString(),
                ),
                const SizedBox(height: 40),
                ItemGrade(getUserGradeIconInfo(1)),
                const SizedBox(height: 12),
                ItemGrade(getUserGradeIconInfo(2)),
                const SizedBox(height: 12),
                ItemGrade(getUserGradeIconInfo(3)),
                const SizedBox(height: 12),
                ItemGrade(getUserGradeIconInfo(4)),
                const SizedBox(height: 12),
                ItemGrade(getUserGradeIconInfo(5)),
                const SizedBox(height: 12),
                Text("* 현재 보상 정보를 준비 중입니다.", style: FortuneTextStyle.body3Light(fontColor: ColorName.grey400)),
                const SizedBox(height: 6),
                Text("* 등급별 혜택 및 선정 기준은 변경될 수 있습니다.", style: FortuneTextStyle.body3Light(fontColor: ColorName.grey400)),
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
                      ColorName.grey900.withOpacity(1.0),
                      ColorName.grey900.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
