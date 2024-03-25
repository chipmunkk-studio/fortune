import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/usecase/marker_obtain_use_case.dart';
import 'package:fortune/presentation-v2/obtain/bloc/fortune_obtain_side_effect.dart';
import 'package:latlong2/latlong.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'fortune_obtain.dart';

class FortuneObtainBloc extends Bloc<FortuneObtainEvent, FortuneObtainViewState>
    with SideEffectBlocMixin<FortuneObtainEvent, FortuneObtainViewState, FortuneObtainSideEffect> {
  final MarkerObtainUseCase markerObtainUseCase;

  FortuneObtainBloc({
    required this.markerObtainUseCase,
  }) : super(FortuneObtainViewState.initial()) {
    on<FortuneObtainInit>(_init);
  }

  FutureOr<void> _init(FortuneObtainInit event, Emitter<FortuneObtainViewState> emit) async {
    final param = event.param;
    final targetMarker = param.marker;
    final ts = param.ts;
    final location = param.location;

    emit(
      state.copyWith(
        processingMarker: targetMarker,
        isObtaining: true,
      ),
    );

    // 마커 획득 처리.
    await _markerObtain(
      targetMarker: targetMarker,
      ts: ts,
      location: location,
      emit: emit,
    );
  }

  FutureOr<void> _markerObtain({
    required MarkerEntity targetMarker,
    required int ts,
    required LatLng location,
    required Emitter<FortuneObtainViewState> emit,
  }) async {
    await markerObtainUseCase(
      targetMarker.id,
      ts,
      location,
    ).then(
      (value) => value.fold(
        (l) {
          produceSideEffect(FortuneObtainError(l));
        },
        (r) {
          if (r.marker.itemType == MarkerItemType.COIN || r.marker.itemType == MarkerItemType.NORMAL) {
            produceSideEffect(FortuneCoinOrNormalObtainSuccess(r));
          }
        },
      ),
    );
  }
}