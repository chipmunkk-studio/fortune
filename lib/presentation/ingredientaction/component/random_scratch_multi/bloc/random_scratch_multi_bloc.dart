import 'dart:async';
import 'dart:math' as math;

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/component/random_scratch_multi/bloc/random_scratch_grid_item.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'random_scratch_multi.dart';

class RandomScratchMultiBloc extends Bloc<RandomScratchMultiEvent, RandomScratchMultiState>
    with SideEffectBlocMixin<RandomScratchMultiEvent, RandomScratchMultiState, RandomScratchMultiSideEffect> {
  static const tag = "[RandomScratchMultiBloc]";

  RandomScratchMultiBloc() : super(RandomScratchMultiState.initial()) {
    on<RandomScratchMultiInit>(init);
    on<RandomScratchMultiEnd>(scratchEnd);
    on<RandomScratchMultiShowReceive>(
      _showReceive,
      transformer: throttle(const Duration(seconds: 3)),
    );
  }

  FutureOr<void> init(RandomScratchMultiInit event, Emitter<RandomScratchMultiState> emit) async {
    math.Random random = math.Random();
    // 선택된 마커가 아닌 것들만 뽑아서 만듬.
    final randomScratchersItems = event.randomScratchIngredients
        .where(
          (element) => element.exposureName != event.randomScratchSelected.ingredient.exposureName,
        )
        .toList();
    Map<String, int> nonWinnerGrid = {};
    // 격자 초기화 (3x3 격자, 총 9개의 슬롯)
    List<RandomScratchGridItem> grid = List.filled(9, RandomScratchGridItem.initial(), growable: false);

    // randomScratcherSelected를 격자 내 3곳에 랜덤하게 배치
    Set<int> selectedPositions = {};
    while (selectedPositions.length < 3) {
      int position = random.nextInt(9);
      if (!selectedPositions.contains(position)) {
        grid[position] = RandomScratchGridItem.initial(
          ingredient: event.randomScratchSelected.ingredient,
          isWinner: true,
        );
        selectedPositions.add(position);
      }
    }

    // 나머지 카드를 randomScratchersItems에서 선택하여 배치
    nonWinnerGrid[event.randomScratchSelected.ingredient.exposureName] = 3;

    if (randomScratchersItems.length < 3) {
      produceSideEffect(RandomScratchMultiError(CommonFailure(errorMessage: '생성할 수 있는 재료가 부족합니다')));
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
            grid[i] = RandomScratchGridItem.initial(ingredient: selectedItem);
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

  FutureOr<void> scratchEnd(RandomScratchMultiEnd event, Emitter<RandomScratchMultiState> emit) {
    // 현재 상태에서 grid 복사
    var newGrid = List<RandomScratchGridItem>.from(state.gridItems);
    // 선택된 아이템의 isScratched를 true로 설정
    newGrid[event.index] = newGrid[event.index].copyWith(isScratched: true);
    // 당첨 카운트 확인
    int winnerCount = newGrid.where((item) => item.isWinner && item.isScratched).length;
    // 3개 이상 당첨된 경우 당첨 처리
    if (winnerCount >= 3) {
      emit(state.copyWith(isObtaining: true));
      add(RandomScratchMultiShowReceive(state.randomScratchSelected));
    }
    // 상태 업데이트
    emit(state.copyWith(gridItems: newGrid));
  }

  FutureOr<void> _showReceive(RandomScratchMultiShowReceive event, Emitter<RandomScratchMultiState> emit) {
    produceSideEffect(
      RandomScratchMultiProgressEnd(
        state.randomScratchSelected,
      ),
    );
  }
}
