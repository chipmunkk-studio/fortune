import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';
import 'package:fortune/presentation/ranking/component/item_ranking.dart';
import 'package:fortune/presentation/ranking/component/item_ranking_content.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/ranking.dart';
import 'component/top_area.dart';

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
  static const offsetVisibleThreshold = 50.0;
  final _router = serviceLocator<FortuneAppRouter>().router;
  final _tracker = serviceLocator<MixpanelTracker>();
  late RankingBloc _bloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tracker.trackEvent('랭킹_랜딩');
    _bloc = BlocProvider.of<RankingBloc>(context);
    _scrollController = ScrollController()..addListener(_onScroll);
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
            skeleton: Container(),
            isLoading: state.isLoading,
            child: state.rankingItems.isNotEmpty
                ? Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopArea(
                            items: state.rankingItems
                                .take(3)
                                .map(
                                  (e) => e as RankingPagingViewItemEntity,
                                )
                                .toList(),
                          ),
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.rankingItems.length - 3,
                              controller: _scrollController,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 44.h),
                              separatorBuilder: (context, index) => Divider(
                                height: 21.h,
                                color: ColorName.grey800,
                              ),
                              itemBuilder: (context, index) {
                                final item = state.rankingItems[index + 3];
                                if (item is RankingPagingViewItemEntity) {
                                  return ItemRanking(
                                    item: item,
                                    index: (index + 4).toString(),
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
                                return Container();
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
                                  SizedBox(height: 20.h),
                                  ItemRankingContent(
                                    nickName: state.me.nickName,
                                    profile: state.me.profile,
                                    index: state.me.index,
                                    count: state.me.count,
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

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;

    if (offset + offsetVisibleThreshold >= max) {
      _bloc.add(RankingNextPage());
    }
  }
}
