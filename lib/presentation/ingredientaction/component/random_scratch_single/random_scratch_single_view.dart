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
import 'package:fortune/presentation/ingredientaction/component/random_scratch_single/random_scratch_single_box.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_response.dart';
import 'package:fortune/presentation/main/main_ext.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/random_scratch_single.dart';

class RandomScratchSingleView extends StatelessWidget {
  final List<IngredientEntity> randomNormalIngredients;
  final IngredientActionParam randomNormalSelected;

  final dartz.Function1<IngredientActionParam, void> onReceive;

  const RandomScratchSingleView({
    super.key,
    required this.randomNormalIngredients,
    required this.randomNormalSelected,
    required this.onReceive,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RandomScratchSingleBloc()
        ..add(
          RandomScratchSingleInit(
            randomNormalSelected: randomNormalSelected,
            randomNormalIngredients: randomNormalIngredients,
          ),
        ),
      child: _RandomScratchSingleView(
        onReceive: onReceive,
      ),
    );
  }
}

class _RandomScratchSingleView extends StatefulWidget {
  final dartz.Function1<IngredientActionParam, void> onReceive;

  const _RandomScratchSingleView({
    required this.onReceive,
  });

  @override
  State<_RandomScratchSingleView> createState() => _RandomScratchSingleViewState();
}

class _RandomScratchSingleViewState extends State<_RandomScratchSingleView> with SingleTickerProviderStateMixin {
  late RandomScratchSingleBloc _bloc;
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
    _bloc = BlocProvider.of<RandomScratchSingleBloc>(context);
  }

  @override
  void dispose() {
    _bloc.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<RandomScratchSingleBloc, RandomScratchSingleSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is RandomScratchSingleProgressEnd) {
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
      child: BlocBuilder<RandomScratchSingleBloc, RandomScratchSingleState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Skeleton(
            isLoading: state.isLoading,
            skeleton: const SizedBox.shrink(),
            child: FortuneScaffold(
              appBar: FortuneCustomAppBar.leadingAppBar(context, onPressed: () {
                _router.pop(context, ScratchCancel());
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
                    style: FortuneTextStyle.body1Regular(
                      color: ColorName.grey200,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<RandomScratchSingleBloc, RandomScratchSingleState>(
                      builder: (context, state) {
                        return RandomScratchSingleBox(
                          coverImage: Assets.images.random.scratchSingleCover.image(),
                          itemImageUrl: state.randomScratchSelected.ingredient.image.imageUrl,
                          onScratch: () => _bloc.add(RandomScratchSingleEnd()),
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
