import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/date.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/domain/entities/common/faq_entity.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/support/component/support_skeleton.dart';
import 'package:foresh_flutter/presentation/support/faq/bloc/faq.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../component/support_card.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<FaqBloc>()..add(FaqInit()),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: "자주 묻는 질문"),
        child: const _FaqPage(),
      ),
    );
  }
}

class _FaqPage extends StatefulWidget {
  const _FaqPage({Key? key}) : super(key: key);

  @override
  State<_FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<_FaqPage> {
  late final FaqBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FaqBloc>(context);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<FaqBloc, FaqSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is FaqError) {
          context.handleError(sideEffect.error);
        }
      },
      child: BlocBuilder<FaqBloc, FaqState>(
        builder: (context, state) {
          return Skeleton(
            isLoading: state.isLoading,
            skeleton: const SupportSkeleton(),
            child: ListView.separated(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: state.items.length,
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
              itemBuilder: (context, index) {
                final item = state.items[index];
                if (item is FaqContentEntity) {
                  return SupportCard(
                    title: item.title,
                    content: item.content,
                    date: FortuneDateExtension.formattedDate(item.createdAt),
                  );
                } else {
                  return Center(
                    child: SizedBox.square(
                      dimension: 32.w,
                      child: const CircularProgressIndicator(
                        color: ColorName.primary,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const tolerance = 0.1; // You can adjust this value
    if (currentScroll <= maxScroll - tolerance &&
        _scrollController.position.userScrollDirection == ScrollDirection.reverse &&
        !_bloc.state.isNextPageLoading) {
      _bloc.add(FaqNextPage());
    }
  }
}
