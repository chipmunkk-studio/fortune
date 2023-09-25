import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';
import 'package:fortune/presentation/gradeguide/bloc/grade_guide.dart';
import 'package:fortune/presentation/gradeguide/component/bottom_grade_area.dart';
import 'package:fortune/presentation/gradeguide/component/item_grade.dart';
import 'package:fortune/presentation/gradeguide/component/middle_percentage.dart';
import 'package:fortune/presentation/gradeguide/component/top_grade_area.dart';

class GradeGuidePage extends StatelessWidget {
  const GradeGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: FortuneTr.msgGradeInfo),
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
                Text(
                  "* ${FortuneTr.msgRewardInProgress}",
                  style: FortuneTextStyle.body3Light(color: ColorName.grey400),
                ),
                const SizedBox(height: 6),
                Text(
                  "* ${FortuneTr.msgGradeChangeNotice}",
                  style: FortuneTextStyle.body3Light(color: ColorName.grey400),
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
