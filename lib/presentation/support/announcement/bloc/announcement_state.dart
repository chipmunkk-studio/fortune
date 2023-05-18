import 'package:foresh_flutter/domain/entities/common/announcement_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_state.freezed.dart';

@freezed
class AnnouncementState with _$AnnouncementState {
  factory AnnouncementState({
    required List<AnnouncementContentParentEntity> items,
    required int page,
    required bool isLoading,
    required bool isNextPageLoading,
  }) = _AnnouncementState;

  factory AnnouncementState.initial() => AnnouncementState(
        items: List.empty(),
        page: 0,
        isLoading: true,
        isNextPageLoading: false,
      );
}
