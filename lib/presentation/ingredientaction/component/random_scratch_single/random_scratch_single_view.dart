import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/component/random_scratch_single_box.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:fortune/presentation/main/main_ext.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

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
  final FToast _fToast = FToast();

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
            Flexible(
              child: BlocBuilder<RandomScratchSingleBloc, RandomScratchSingleState>(
                builder: (context, state) {
                  return RandomScratchSingleBox(
                    coverImage: Assets.images.scratch.image(),
                    itemImageUrl: state.randomScratchSelected.ingredient.image.imageUrl,
                    onScratch: () => _bloc.add(RandomScratchSingleEnd()),
                    animation: _animation,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
