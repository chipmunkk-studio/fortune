import 'fortune_user_entity.dart';
import 'marker_entity.dart';
import 'picked_item_entity.dart';
import 'scratch_cover_entity.dart';

class MarkerObtainEntity {
  final MarkerEntity marker;
  final FortuneUserEntity user;
  final PickedItemEntity pickedItem;
  final ScratchCoverEntity cover;

  MarkerObtainEntity({
    required this.marker,
    required this.user,
    required this.pickedItem,
    required this.cover,
  });

  factory MarkerObtainEntity.initial() => MarkerObtainEntity(
        marker: MarkerEntity.initial(),
        user: FortuneUserEntity.empty(),
        pickedItem: PickedItemEntity.initial(),
        cover: ScratchCoverEntity.initial(),
      );
}
