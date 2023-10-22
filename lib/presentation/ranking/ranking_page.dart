import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';
import 'package:fortune/presentation/ranking/component/item_ranking.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/ranking.dart';
import 'component/top_area.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

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
  const _RankingPage({Key? key}) : super(key: key);

  @override
  State<_RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<_RankingPage> {
  static const offsetVisibleThreshold = 50.0;
  final _router = serviceLocator<FortuneAppRouter>().router;
  late RankingBloc _bloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
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
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<RankingBloc, RankingState>(
        buildWhen: (previous, current) => previous.rankingItems != current.rankingItems,
        builder: (context, state) {
          return Skeleton(
            skeleton: Container(),
            isLoading: state.isLoading,
            child: state.rankingItems.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopArea(items: state.rankingItems.take(3).map((e) => e as RankingPagingViewItemEntity).toList()),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.rankingItems.length - 3,
                          controller: _scrollController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          separatorBuilder: (context, index) => const Divider(
                            height: 40,
                            color: ColorName.grey800,
                          ),
                          itemBuilder: (context, index) {
                            final item = state.rankingItems[index + 3];
                            if (item is RankingPagingViewItemEntity) {
                              return ItemRanking(
                                item: item,
                                index: index + 1,
                              );
                            } else {
                              return const Center(
                                child: SizedBox.square(
                                  dimension: 32,
                                  child: CircularProgressIndicator(
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
