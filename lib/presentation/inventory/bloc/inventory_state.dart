import 'package:foresh_flutter/domain/entities/inventory_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_state.freezed.dart';

@freezed
class InventoryState with _$InventoryState {
  factory InventoryState({
    required String nickname,
    required String profileImage,
    required List<InventoryMarkerEntity> markers,
  }) = _InventoryState;

  factory InventoryState.initial() => InventoryState(
        nickname: "",
        profileImage: "",
        markers: List.empty(),
      );
}
