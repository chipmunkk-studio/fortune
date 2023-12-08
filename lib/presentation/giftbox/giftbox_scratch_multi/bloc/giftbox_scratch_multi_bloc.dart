import 'dart:async';
import 'dart:math' as math;

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'giftbox_scratch_grid_item.dart';
import 'giftbox_scratch_multi.dart';

class GiftboxScratchMultiBloc extends Bloc<GiftboxScratchMultiEvent, GiftboxScratchMultiState>
    with SideEffectBlocMixin<GiftboxScratchMultiEvent, GiftboxScratchMultiState, GiftboxScratchMultiSideEffect> {
  static const tag = "[GiftboxScratchMultiBloc]";

  GiftboxScratchMultiBloc() : super(GiftboxScratchMultiState.initial()) {
    on<GiftboxScratchMultiInit>(init);
    on<GiftboxScratchMultiEnd>(scratchEnd);
    on<GiftboxScratchMultiShowReceive>(
      _showReceive,
      transformer: throttle(const Duration(seconds: 3)),
    );
  }

  FutureOr<void> init(GiftboxScratchMultiInit event, Emitter<GiftboxScratchMultiState> emit) async {
    math.Random random = math.Random();
    // 선택된 마커가 아닌 것들만 뽑아서 만듬.
    final randomScratchersItems = event.randomScratchIngredients
        .where(
          (element) => element.exposureName != event.randomScratchSelected.ingredient.exposureName,
        )
        .toList();
    Map<String, int> nonWinnerGrid = {};
    // 격자 초기화 (3x3 격자, 총 9개의 슬롯)
    List<GiftboxScratchGridItem> grid = List.filled(9, GiftboxScratchGridItem.initial(), growable: false);

    // randomScratcherSelected를 격자 내 3곳에 랜덤하게 배치
    Set<int> selectedPositions = {};
    while (selectedPositions.length < 3) {
      int position = random.nextInt(9);
      if (!selectedPositions.contains(position)) {
        grid[position] = GiftboxScratchGridItem.initial(
          ingredient: event.randomScratchSelected.ingredient,
          isWinner: true,
        );
        selectedPositions.add(position);
      }
    }

    // 나머지 카드를 randomScratchersItems에서 선택하여 배치
    nonWinnerGrid[event.randomScratchSelected.ingredient.exposureName] = 3;

    if (randomScratchersItems.length < 3) {
      produceSideEffect(GiftboxScratchMultiError(CommonFailure(errorMessage: '생성할 수 있는 재료가 부족합니다')));
      return;
    }

    for (int i = 0; i < grid.length; i++) {
      if (grid[i].ingredient.id == -1) {
        IngredientEntity selectedItem;
        bool itemSelected = false;
        while (!itemSelected) {
          int randomIndex = random.nextInt(randomScratchersItems.length);
          selectedItem = randomScratchersItems[randomIndex];
          int currentCount = nonWinnerGrid[selectedItem.exposureName] ?? 0;

          if (currentCount < 2) {
            grid[i] = GiftboxScratchGridItem.initial(ingredient: selectedItem);
            nonWinnerGrid[selectedItem.exposureName] = currentCount + 1;
            itemSelected = true;
          }
        }
      }
    }

    emit(
      state.copyWith(
        gridItems: grid,
        randomScratchSelected: event.randomScratchSelected,
        isLoading: false,
      ),
    );
  }

  FutureOr<void> scratchEnd(GiftboxScratchMultiEnd event, Emitter<GiftboxScratchMultiState> emit) {
    // 현재 상태에서 grid 복사
    add(GiftboxScratchMultiShowReceive(state.randomScratchSelected));
  }

  FutureOr<void> _showReceive(GiftboxScratchMultiShowReceive event, Emitter<GiftboxScratchMultiState> emit) {
    produceSideEffect(
      GiftboxScratchMultiProgressEnd(
        state.randomScratchSelected,
      ),
    );
  }
}
