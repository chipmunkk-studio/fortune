import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';
import 'package:fortune/presentation/ranking/component/item_ranking.dart';
import 'package:fortune/presentation/ranking/component/item_ranking_content.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/ranking.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<RankingBloc>()..add(RankingInit()),
      child: FortuneScaffold(
        padding: EdgeInsets.zero,
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: FortuneTr.msgHallOfFame),
        child: const _RankingPage(),
      ),
    );
  }
}

class _RankingPage extends StatefulWidget {
  const _RankingPage();

  @override
  State<_RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<_RankingPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  final _tracker = serviceLocator<MixpanelTracker>();
  late RankingBloc _bloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tracker.trackEvent('랭킹_랜딩');
    _bloc = BlocProvider.of<RankingBloc>(context);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<RankingBloc, RankingSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is RankingError) {
          dialogService.showAppErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<RankingBloc, RankingState>(
        buildWhen: (previous, current) => previous.rankingItems != current.rankingItems,
        builder: (context, state) {
          return Skeleton(
            skeleton: const _RankingPageSkeleton(),
            isLoading: state.isLoading,
            child: state.rankingItems.isNotEmpty
                ? Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Assets.icons.icArrowsDownUp.svg(width: 16, height: 16),
                              const SizedBox(width: 3),
                              Text(
                                FortuneTr.msgOrderOfMissionCompletion,
                                style: FortuneTextStyle.body3Semibold(
                                  color: ColorName.grey200,
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.rankingItems.length,
                              controller: _scrollController,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 4, bottom: 100),
                              separatorBuilder: (context, index) => Divider(height: 21.h, color: ColorName.grey800),
                              itemBuilder: (context, index) {
                                final item = state.rankingItems[index];
                                if (item is RankingPagingViewItemEntity) {
                                  return ItemRanking(
                                    item: item,
                                    index: index + 1,
                                  );
                                } else {
                                  return Center(
                                    child: SizedBox.square(
                                      dimension: 32.h,
                                      child: const CircularProgressIndicator(
                                        color: ColorName.primary,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: -1.h,
                        left: 0,
                        right: 0,
                        child: BlocBuilder<RankingBloc, RankingState>(
                          buildWhen: (previous, current) => previous.me != current.me,
                          builder: (context, state) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32.r),
                                  topRight: Radius.circular(32.r),
                                ),
                                color: ColorName.grey800,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 12.h),
                                  ItemRankingContent(
                                    nickName: state.me.nickName,
                                    profile: state.me.profile,
                                    grade: state.me.grade,
                                    level: state.me.level,
                                    index: int.parse(state.me.index),
                                    count: state.me.count,
                                    isMe: true,
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class _RankingPageSkeleton extends StatelessWidget {
  const _RankingPageSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              SkeletonLine(
                style: SkeletonLineStyle(
                  width: 120,
                  height: 30,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 50,
              randomLength: true,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          const SizedBox(height: 20),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 50,
              randomLength: true,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          const SizedBox(height: 20),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 50,
              randomLength: true,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          const SizedBox(height: 20),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 50,
              randomLength: true,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          const SizedBox(height: 20),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 50,
              randomLength: true,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          const SizedBox(height: 20),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 50,
              randomLength: true,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ],
      ),
    );
  }
}
