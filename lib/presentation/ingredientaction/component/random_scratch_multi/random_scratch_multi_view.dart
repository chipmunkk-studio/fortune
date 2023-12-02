import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/toast.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/component/random_scratch_multi_box.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:fortune/presentation/main/main_ext.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/random_scratch_multi.dart';

class RandomScratchMultiView extends StatelessWidget {
  final List<IngredientEntity> randomNormalIngredients;
  final IngredientActionParam randomNormalSelected;

  final dartz.Function1<IngredientActionParam, void> onReceive;

  const RandomScratchMultiView({
    super.key,
    required this.randomNormalIngredients,
    required this.randomNormalSelected,
    required this.onReceive,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RandomScratchMultiBloc()
        ..add(
          RandomScratchMultiInit(
            randomScratchSelected: randomNormalSelected,
            randomScratchIngredients: randomNormalIngredients,
          ),
        ),
      child: _RandomScratchMultiView(
        onReceive: onReceive,
      ),
    );
  }
}

class _RandomScratchMultiView extends StatefulWidget {
  final dartz.Function1<IngredientActionParam, void> onReceive;

  const _RandomScratchMultiView({
    required this.onReceive,
  });

  @override
  State<_RandomScratchMultiView> createState() => _RandomScratchMultiViewState();
}

class _RandomScratchMultiViewState extends State<_RandomScratchMultiView> with SingleTickerProviderStateMixin {
  late RandomScratchMultiBloc _bloc;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final FToast _fToast = FToast();

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
    _bloc = BlocProvider.of<RandomScratchMultiBloc>(context);
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
    return BlocSideEffectListener<RandomScratchMultiBloc, RandomScratchMultiSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is RandomScratchMultiError) {
          dialogService.showAppErrorDialog(
            context,
            sideEffect.error,
            needToFinish: true,
          );
        } else if (sideEffect is RandomScratchMultiProgressEnd) {
          final ingredient = sideEffect.randomNormalSelected.ingredient;
          _animationController.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              dialogService.showFortuneDialog(
                context,
                dismissOnBackKeyPress: true,
                dismissOnTouchOutside: true,
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
      child: FortuneScaffold(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<RandomScratchMultiBloc, RandomScratchMultiState>(
                builder: (context, state) {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: state.gridItems.length,
                    itemBuilder: (context, index) {
                      final item = state.gridItems[index];
                      return RandomScratchMultiBox(
                        coverImage: Assets.images.scratch.image(),
                        itemImageUrl: item.ingredient.image.imageUrl,
                        animation: item.isWinner ? _animation : null,
                        onScratch: () {
                          _bloc.add(RandomScratchMultiEnd(item: item, index: index));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showRequireProgressToast({
    required String message,
  }) {
    _fToast.showToast(
      child: fortuneToastContent(
        icon: Assets.icons.icWarningCircle24.svg(),
        content: message,
      ),
      positionedToastBuilder: (context, child) => Positioned(
        bottom: 40,
        left: 0,
        right: 0,
        child: child,
      ),
      toastDuration: const Duration(seconds: 2),
    );
  }
}
