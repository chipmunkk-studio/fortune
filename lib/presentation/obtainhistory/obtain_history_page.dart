import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/obtain_history.dart';
import 'component/item_obtain_history.dart';
import 'component/obtain_history_skeleton.dart';

class ObtainHistoryPage extends StatelessWidget {
  final String searchText;

  const ObtainHistoryPage({
    Key? key,
    required this.searchText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ObtainHistoryBloc>()..add(ObtainHistoryInit(searchText)),
      child: const _ObtainHistoryPage(),
    );
  }
}

class _ObtainHistoryPage extends StatefulWidget {
  const _ObtainHistoryPage({Key? key}) : super(key: key);

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
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 65),
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              child: AnimationSearchBar(
                backIconColor: Colors.white,
                centerTitle: '포춘 스팟',
                searchIconColor: Colors.white,
                textStyle: FortuneTextStyle.body2Regular(),
                hintStyle: FortuneTextStyle.body1Regular(fontColor: Colors.grey),
                closeIconColor: Colors.white,
                cursorColor: Colors.white,
                hintText: "검색어를 입력하세요",
                centerTitleStyle: FortuneTextStyle.subTitle3SemiBold(),
                onChanged: (text) => _bloc.add(ObtainHistorySearchText(text)),
                searchTextEditingController: _controller,
                horizontalPadding: 8,
              ),
            ),
          ),
        ),
        child: BlocBuilder<ObtainHistoryBloc, ObtainHistoryState>(
          buildWhen: (previous, current) => previous.histories != current.histories,
          builder: (context, state) {
            return Skeleton(
              skeleton: const ObtainHistorySkeleton(),
              isLoading: state.isLoading,
              child: state.histories.isNotEmpty
                  ? ListView.separated(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.histories.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 20),
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
                  : Center(
                      child: Text(
                        "히스토리가 없습니다",
                        style: FortuneTextStyle.subTitle3SemiBold(),
                      ),
                    ),
            );
          },
        ),
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
