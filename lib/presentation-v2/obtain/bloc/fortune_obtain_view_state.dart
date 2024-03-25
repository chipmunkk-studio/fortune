import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_obtain_view_state.freezed.dart';

@freezed
class FortuneObtainViewState with _$FortuneObtainViewState {
  factory FortuneObtainViewState({
    required MarkerEntity processingMarker,
    required MarkerEntity responseMarker,
    required bool isObtaining,
  }) = _FortuneObtainViewState;

  factory FortuneObtainViewState.initial() => FortuneObtainViewState(
        processingMarker: MarkerEntity.initial(),
        responseMarker: MarkerEntity.initial(),
        isObtaining: false,
      );
}
