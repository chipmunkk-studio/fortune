import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:fortune/presentation/main/main_ext.dart';
import 'package:scratcher/scratcher.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../component/default_background_view.dart';
import 'bloc/giftbox_scratch_multi.dart';
import 'giftbox_scratch_multi_box.dart';

class GiftboxScratchMultiView extends StatelessWidget {
  final List<IngredientEntity> randomNormalIngredients;
  final GiftboxActionParam randomNormalSelected;

  final dartz.Function1<GiftboxActionParam, void> onReceive;

  const GiftboxScratchMultiView({
    super.key,
    required this.randomNormalIngredients,
    required this.randomNormalSelected,
    required this.onReceive,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GiftboxScratchMultiBloc()
        ..add(
          GiftboxScratchMultiInit(
            randomScratchSelected: randomNormalSelected,
            randomScratchIngredients: randomNormalIngredients,
          ),
        ),
      child: _GiftboxScratchMultiView(
        onReceive: onReceive,
      ),
    );
  }
}

class _GiftboxScratchMultiView extends StatefulWidget {
  final dartz.Function1<GiftboxActionParam, void> onReceive;

  const _GiftboxScratchMultiView({
    required this.onReceive,
  });

  @override
  State<_GiftboxScratchMultiView> createState() => _GiftboxScratchMultiViewState();
}

class _GiftboxScratchMultiViewState extends State<_GiftboxScratchMultiView> with SingleTickerProviderStateMixin {
  late GiftboxScratchMultiBloc _bloc;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _router = serviceLocator<FortuneAppRouter>().router;

  // 스크래치 커버 리스트.
  final List<Image> scratchMultiCoverImages = [
    Assets.images.random.scratchMultiCover0.image(),
    Assets.images.random.scratchMultiCover1.image(),
    Assets.images.random.scratchMultiCover2.image(),
    Assets.images.random.scratchMultiCover3.image(),
    Assets.images.random.scratchMultiCover4.image(),
    Assets.images.random.scratchMultiCover5.image(),
    Assets.images.random.scratchMultiCover6.image(),
    Assets.images.random.scratchMultiCover7.image(),
    Assets.images.random.scratchMultiCover8.image(),
  ];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addStatusListener(
        (listener) {
          if (listener == AnimationStatus.completed) {
            _animationController.reverse();
          }
        },
      );
    _animation = Tween(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn,
      ),
    );
    _bloc = BlocProvider.of<GiftboxScratchMultiBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<GiftboxScratchMultiBloc, GiftboxScratchMultiSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is GiftboxScratchMultiError) {
          dialogService.showAppErrorDialog(
            context,
            sideEffect.error,
          );
        } else if (sideEffect is GiftboxScratchMultiProgressEnd) {
          final ingredient = sideEffect.randomNormalSelected.ingredient;
          _animationController.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              dialogService.showFortuneDialog(
                context,
                dismissOnBackKeyPress: false,
                dismissOnTouchOutside: false,
                subTitle: ingredient.exposureName,
                btnOkText: FortuneTr.msgReceive,
                btnOkPressed: () => widget.onReceive(sideEffect.randomNormalSelected),
                topContent: buildIngredientByPlayType(
                  ingredient,
                  width: 84,
                  height: 84,
                  imageShape: ImageShape.none,
                ),
              );
            }
          });
          _animationController.forward();
        }
      },
      child: BlocBuilder<GiftboxScratchMultiBloc, GiftboxScratchMultiState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Skeleton(
            isLoading: state.isLoading,
            skeleton: const SizedBox.shrink(),
            child: Stack(
              children: [
                FortuneScaffold(
                  appBar: FortuneCustomAppBar.leadingAppBar(context, onPressed: () {
                    _router.pop(context);
                  }),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        FortuneTr.msgTryScratching,
                        style: FortuneTextStyle.headLine2(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        FortuneTr.msgWhatHappensThreeMatches,
                        style: FortuneTextStyle.body1Regular(
                          color: ColorName.grey200,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Flexible(
                        child: BlocBuilder<GiftboxScratchMultiBloc, GiftboxScratchMultiState>(
                          builder: (context, state) {
                            return Scratcher(
                              accuracy: ScratchAccuracy.high,
                              image: Assets.images.random.scratchSingleCover.image(),
                              color: Colors.transparent,
                              brushSize: 48,
                              threshold: 65,
                              onThreshold: () {
                                _bloc.add(GiftboxScratchMultiEnd());
                              },
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                shrinkWrap: true,
                                itemCount: state.gridItems.length,
                                itemBuilder: (context, index) {
                                  final item = state.gridItems[index];
                                  return GiftboxScratchMultiBox(
                                    itemImageUrl: item.ingredient.image.imageUrl,
                                    animation: item.isWinner ? _animation : null,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: FortuneTr.msgGoldenFourLeafClover,
                                    style: FortuneTextStyle.body2Semibold(color: ColorName.primary),
                                  ),
                                  TextSpan(
                                    text: ' ${FortuneTr.msgMarkerIs}',
                                    style: FortuneTextStyle.body2Semibold(color: ColorName.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              FortuneTr.msgHiddenInScratch,
                              style: FortuneTextStyle.body2Semibold(color: ColorName.white),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<GiftboxScratchMultiBloc, GiftboxScratchMultiState>(
                        buildWhen: (previous, current) => previous.isObtaining != current.isObtaining,
                        builder: (context, state) {
                          return const DefaultBackgroundView();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
