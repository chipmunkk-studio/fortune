import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:fortune/presentation/main/main_ext.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/giftbox_scratch_single.dart';
import 'giftbox_scratch_single_box.dart';

class GiftboxScratchSingleView extends StatelessWidget {
  final List<IngredientEntity> randomNormalIngredients;
  final GiftboxActionParam randomNormalSelected;

  final dartz.Function1<GiftboxActionParam, void> onReceive;

  const GiftboxScratchSingleView({
    super.key,
    required this.randomNormalIngredients,
    required this.randomNormalSelected,
    required this.onReceive,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GiftboxScratchSingleBloc()
        ..add(
          GiftboxScratchSingleInit(
            randomNormalSelected: randomNormalSelected,
            randomNormalIngredients: randomNormalIngredients,
          ),
        ),
      child: _GiftboxScratchSingleView(
        onReceive: onReceive,
      ),
    );
  }
}

class _GiftboxScratchSingleView extends StatefulWidget {
  final dartz.Function1<GiftboxActionParam, void> onReceive;

  const _GiftboxScratchSingleView({
    required this.onReceive,
  });

  @override
  State<_GiftboxScratchSingleView> createState() => _GiftboxScratchSingleViewState();
}

class _GiftboxScratchSingleViewState extends State<_GiftboxScratchSingleView> with SingleTickerProviderStateMixin {
  late GiftboxScratchSingleBloc _bloc;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _router = serviceLocator<FortuneAppRouter>().router;

  @override
  void initState() {
    super.initState();
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
    _bloc = BlocProvider.of<GiftboxScratchSingleBloc>(context);
  }

  @override
  void dispose() {
    _bloc.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<GiftboxScratchSingleBloc, GiftboxScratchSingleSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is GiftboxScratchSingleProgressEnd) {
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
                ),
              );
            }
          });
          _animationController.forward();
        }
      },
      child: BlocBuilder<GiftboxScratchSingleBloc, GiftboxScratchSingleState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Skeleton(
            isLoading: state.isLoading,
            skeleton: const SizedBox.shrink(),
            child: FortuneScaffold(
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
                    FortuneTr.msgGuaranteedMarkerReward,
                    style: FortuneTextStyle.body1Light(
                      color: ColorName.grey200,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<GiftboxScratchSingleBloc, GiftboxScratchSingleState>(
                      builder: (context, state) {
                        return GiftboxScratchSingleBox(
                          coverImage: Assets.images.random.scratchSingleCover.image(),
                          itemImageUrl: state.randomScratchSelected.ingredient.image.imageUrl,
                          onScratch: () => _bloc.add(GiftboxScratchSingleEnd()),
                          animation: _animation,
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
                                text: FortuneTr.msgGreenFourLeafClover,
                                style: FortuneTextStyle.body2Semibold(color: ColorName.primary),
                              ),
                              TextSpan(
                                text: " ${FortuneTr.msgMarkerIs}",
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
