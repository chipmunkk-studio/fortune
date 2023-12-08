import 'dart:async';
import 'dart:math' as math;

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/usecase/get_ingredients_by_type_use_case.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'giftbox_action.dart';

class GiftboxActionBloc extends Bloc<GiftboxActionEvent, GiftboxActionState>
    with SideEffectBlocMixin<GiftboxActionEvent, GiftboxActionState, GiftboxActionSideEffect> {
  final GetIngredientsByTypeUseCase getIngredientsByTypeUseCase;
  final Environment env;

  GiftboxActionBloc({
    required this.getIngredientsByTypeUseCase,
    required this.env,
  }) : super(GiftboxActionState.initial()) {
    on<GiftboxActionInit>(init);
    on<GiftboxActionShowAdCounting>(showAdProcess);
    on<GiftboxActionObtainSuccess>(
      obtainSuccess,
      transformer: throttle(
        const Duration(seconds: 1),
      ),
    );
  }

  FutureOr<void> init(GiftboxActionInit event, Emitter<GiftboxActionState> emit) async {
    emit(state.copyWith(adMobStatus: env.remoteConfig.admobStatus));
    await _processGiftboxAction(event, emit);
  }

  _processGiftboxAction(
    GiftboxActionInit event,
    Emitter<GiftboxActionState> emit,
  ) async {
    switch (event.param.giftType) {
      // 랜덤 싱글/멀티 일 경우.
      case GiftboxType.random:
        await processRandomIngredient(event.param, emit);
        break;
      // 코인 일 경우.
      case GiftboxType.coin:
        await processCoinIngredient(event.param, emit);
        break;
      default:
        break;
    }
  }

  // 코인 일 경우.
  Future<void> processCoinIngredient(GiftboxActionParam param, Emitter<GiftboxActionState> emit) async {
    produceSideEffect(GiftboxProcessShowAdAction(param, state.adMobStatus));
    emit(
      state.copyWith(
        entity: param,
        isLoading: false,
      ),
    );
  }

  // 랜덤노말 타입 일 경우.
  Future<void> processRandomIngredient(
    GiftboxActionParam param,
    Emitter<GiftboxActionState> emit,
  ) async {
    /// 노말과 랜덤 스크래치(싱글)만 골라옴.
    final result = await getIngredientsByTypeUseCase([
      IngredientType.coin,
      IngredientType.normal,
      if (param.ingredient.type == IngredientType.randomScratchSingle) IngredientType.randomScratchSingleOnly,
      if (param.ingredient.type == IngredientType.randomScratchMulti) IngredientType.randomScratchMultiOnly,
    ]);

    result.fold(
      (failure) => produceSideEffect(GiftboxActionError(failure)), // 에러 처리 추가
      (ingredients) {
        if (ingredients.isNotEmpty) {
          List<IngredientEntity> randomNormalIngredients = [];
          for (var ingredient in ingredients) {
            randomNormalIngredients.add(ingredient);
            if (ingredient.type == IngredientType.normal) {
              randomNormalIngredients.addAll(List.generate(100, (index) => ingredient));
            }
          }
          // 노말 타입만 10배로 늘림.
          final randomIndex = math.Random().nextInt(randomNormalIngredients.length);
          final nextParam = param.copyWith(
            ingredient: randomNormalIngredients[randomIndex].copyWith(
              // 랜덤박스에 있는 거리 그대로 복사.
              distance: param.ingredient.distance,
              // 랜덤박스에 있는 티켓 수 복사.
              rewardTicket: param.ingredient.rewardTicket,
              // 랜덤박스의 타입 그대로 복사.
              type: param.ingredient.type,
            ),
          );
          emit(
            state.copyWith(
              entity: param,
              randomScratcherSelected: nextParam,
              randomScratchersItems: ingredients,
              isLoading: false,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> showAdProcess(GiftboxActionShowAdCounting event, Emitter<GiftboxActionState> emit) {
    produceSideEffect(
      GiftboxProcessObtainAction(
        ingredient: state.entity.ingredient,
      ),
    );
  }

  FutureOr<void> obtainSuccess(GiftboxActionObtainSuccess event, Emitter<GiftboxActionState> emit) {
    produceSideEffect(
      GiftboxProcessObtainAction(
        ingredient: event.entity,
      ),
    );
  }
}
