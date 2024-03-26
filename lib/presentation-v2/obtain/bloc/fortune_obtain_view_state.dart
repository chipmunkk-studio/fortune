import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_obtain_view_state.freezed.dart';

@freezed
class FortuneObtainViewState with _$FortuneObtainViewState {
  factory FortuneObtainViewState({
    required MarkerEntity processingMarker,
    required MarkerObtainEntity responseEntity,
    required ObtainState targetState,
  }) = _FortuneObtainViewState;

  factory FortuneObtainViewState.initial() => FortuneObtainViewState(
        processingMarker: MarkerEntity.initial(),
        responseEntity: MarkerObtainEntity.initial(),
        targetState: ObtainState.NONE,
      );
}

enum ObtainState {
  NONE,
  PROCESSING,
  COIN,
  NORMAL,
  SCRATCH,
}

getObtainState(MarkerItemType type) {
  if (type == MarkerItemType.SCRATCH) {
    return ObtainState.SCRATCH;
  } else if (type == MarkerItemType.NORMAL) {
    return ObtainState.NORMAL;
  } else if (type == MarkerItemType.COIN) {
    return ObtainState.COIN;
  } else {
    return ObtainState.NONE;
  }
}
