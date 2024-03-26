import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';
import 'package:fortune/domain/entity/picked_item_entity.dart';
import 'package:fortune/domain/entity/scratch_cover_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_obtain_view_state.freezed.dart';

@freezed
class FortuneObtainViewState with _$FortuneObtainViewState {
  factory FortuneObtainViewState({
    required MarkerEntity processingMarker,
    required MarkerObtainEntity responseEntity,
    required MarkerItemType targetState,
  }) = _FortuneObtainViewState;

  factory FortuneObtainViewState.initial() => FortuneObtainViewState(
        processingMarker: MarkerEntity.initial(),
        responseEntity: MarkerObtainEntity.initial(),
        targetState: MarkerItemType.NONE,
      );
}