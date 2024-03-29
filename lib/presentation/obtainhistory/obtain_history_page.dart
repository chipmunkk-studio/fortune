import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/obtain_history_entity.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/obtain_history.dart';
import 'component/item_obtain_history.dart';
import 'component/obtain_history_skeleton.dart';

class ObtainHistoryPage extends StatelessWidget {
  final String searchText;

  const ObtainHistoryPage({
    super.key,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ObtainHistoryBloc>()..add(ObtainHistoryInit(searchText)),
      child: const _ObtainHistoryPage(),
    );
  }
}

class _ObtainHistoryPage extends StatefulWidget {
  const _ObtainHistoryPage();

  @override
  State<_ObtainHistoryPage> createState() => _ObtainHistoryPageState();
}

class _ObtainHistoryPageState extends State<_ObtainHistoryPage> {
  static const offsetVisibleThreshold = 50.0;
  final TextEditingController _controller = TextEditingController();
  late ObtainHistoryBloc _bloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ObtainHistoryBloc>(context);
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _bloc.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<ObtainHistoryBloc, ObtainHistorySideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is ObtainHistoryNextPage) {
        } else if (sideEffect is ObtainHistoryInitSearchText) {
          _controller.text = sideEffect.text;
        }
      },
      child: FortuneScaffold(
        padding: EdgeInsets.zero,
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 65),
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              child: AnimationSearchBar(
                backIconColor: Colors.white,
                centerTitle: FortuneTr.historyFortuneSpot,
                searchIconColor: Colors.white,
                searchBarHeight: 56,
                textStyle: FortuneTextStyle.body1Regular(),
                hintStyle: FortuneTextStyle.body1Regular(color: ColorName.grey200),
                closeIconColor: Colors.white,
                cursorColor: Colors.white,
                hintText: FortuneTr.historyFortuneSpotSearchInput,
                centerTitleStyle: FortuneTextStyle.subTitle2SemiBold(),
                onChanged: (text) => _bloc.add(ObtainHistorySearchText(text)),
                searchTextEditingController: _controller,
                horizontalPadding: 8,
              ),
            ),
          ),
        ),
        child: BlocBuilder<ObtainHistoryBloc, ObtainHistoryState>(
          buildWhen: (previous, current) =>
              previous.histories != current.histories || previous.isSearching != current.isSearching,
          builder: (context, state) {
            return Skeleton(
              skeleton: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: ObtainHistorySkeleton(),
              ),
              isLoading: state.isLoading,
              child: state.isSearching
                  ? _buildTopCenterLog(
                      FortuneTr.msgSearchingHistory,
                      color: ColorName.grey400,
                    )
                  : state.histories.isNotEmpty
                      ? ListView.separated(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.histories.length,
                          padding: const EdgeInsets.only(top: 16),
                          separatorBuilder: (context, index) => const Divider(
                            height: 36,
                            thickness: 0.5,
                            color: ColorName.grey700,
                          ),
                          itemBuilder: (context, index) {
                            final item = state.histories[index];
                            if (item is ObtainHistoryContentViewItem) {
                              return ItemObtainHistory(item);
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
                          },
                        )
                      : _buildTopCenterLog(
                          FortuneTr.noHistory,
                          color: ColorName.white,
                        ),
            );
          },
        ),
      ),
    );
  }

  _buildTopCenterLog(String message, {required Color color}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            message,
            style: FortuneTextStyle.body1Regular(color: color),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;

    if (offset + offsetVisibleThreshold >= max) {
      _bloc.add(ObtainHistoryNextPage());
    }
  }
}
