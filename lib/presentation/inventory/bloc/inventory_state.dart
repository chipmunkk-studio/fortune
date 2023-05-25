import 'package:foresh_flutter/domain/entities/inventory_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_state.freezed.dart';

@freezed
class InventoryState with _$InventoryState {
  factory InventoryState({
    required String nickname,
    required String profileImage,
    required List<InventoryMarkerEntity> markers,
    required bool isLoading,
    required InventoryTabMission currentTab,
  }) = _InventoryState;

  factory InventoryState.initial() => InventoryState(
        nickname: "",
        profileImage: "",
        markers: List.empty(),
        isLoading: true,
        currentTab: InventoryTabMission.round,
      );
}

enum InventoryTabMission {
  ordinary,
  round,
}
