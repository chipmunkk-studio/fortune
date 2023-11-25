import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/toast.dart';
import 'package:fortune/core/widgets/button/fortune_text_button.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:fortune/presentation/main/main_ext.dart';
import 'package:scratcher/scratcher.dart';
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
  dartz.Function1<IngredientActionParam, void> onReceive;

  _RandomScratchSingleView({
    required this.onReceive,
  });

  @override
  State<_RandomScratchSingleView> createState() => _RandomScratchSingleViewState();
}

class _RandomScratchSingleViewState extends State<_RandomScratchSingleView> with SingleTickerProviderStateMixin {
  final key = GlobalKey<ScratcherState>();
  late RandomScratchSingleBloc _bloc;

  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RandomScratchSingleBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<RandomScratchSingleBloc, RandomScratchSingleSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is RandomScratchSingleProgressEnd) {
          final ingredient = sideEffect.randomNormalSelected.ingredient;
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
      },
      child: FortuneScaffold(
        child: Column(
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FortuneTextButton(
                    onPress: () {
                      key.currentState?.reset(
                        duration: const Duration(milliseconds: 2000),
                      );
                    },
                    text: '새로고침',
                  ),
                  FortuneTextButton(
                    onPress: () {
                      key.currentState?.reveal(
                        duration: const Duration(milliseconds: 2000),
                      );
                    },
                    text: '다보이기',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<RandomScratchSingleBloc, RandomScratchSingleState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  color: Colors.black,
                  child: Text(
                    '${state.progress.floor().toString()}% '
                    '(${state.thresholdReached ? '다긁음' : '긁는중'})',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<RandomScratchSingleBloc, RandomScratchSingleState>(
              builder: (context, state) {
                return Scratcher(
                  key: key,
                  accuracy: ScratchAccuracy.low,
                  image: Assets.images.scratch.image(),
                  brushSize: state.brushSize,
                  threshold: state.threshold,
                  onThreshold: () => _bloc.add(RandomScratchSingleEnd()),
                  onChange: (value) => _bloc.add(RandomScratchSingleProgress(progress: value)),
                  onScratchStart: () {},
                  onScratchUpdate: () {},
                  onScratchEnd: () {
                    if (!state.thresholdReached) {
                      _showRequireProgressToast(message: '조금만 더 긁어보세요!');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: FortuneCachedNetworkImage(
                      imageUrl: state.randomNormalSelected.ingredient.imageUrl,
                      imageShape: ImageShape.squircle,
                      width: state.size,
                      height: state.size,
                    ),
                  ),
                );
              },
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
