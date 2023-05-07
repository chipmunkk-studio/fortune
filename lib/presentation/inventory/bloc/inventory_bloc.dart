import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/usecases/obtain_inventory_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'inventory.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState>
    with SideEffectBlocMixin<InventoryEvent, InventoryState, InventorySideEffect> {
  static const tag = "[CountryCodeBloc]";

  final ObtainInventoryUseCase obtainInventoryUseCase;

  InventoryBloc({
    required this.obtainInventoryUseCase,
  }) : super(InventoryState.initial()) {
    on<InventoryInit>(init);
  }

  FutureOr<void> init(InventoryInit event, Emitter<InventoryState> emit) async {
    await obtainInventoryUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(InventoryError(l)),
        (r) {
          emit(
            state.copyWith(
              nickname: r.nickname,
              profileImage: r.profileImage,
              markers: r.markers,
            ),
          );
        },
      ),
    );
  }
}
