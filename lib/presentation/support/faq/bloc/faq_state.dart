import 'package:foresh_flutter/domain/entities/common/faq_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'faq_state.freezed.dart';

@freezed
class FaqState with _$FaqState {
  factory FaqState({
    required List<FaqContentParentEntity> items,
    required int page,
    required bool isLoading,
    required bool isNextPageLoading,
  }) = _FaqState;

  factory FaqState.initial() => FaqState(
        items: List.empty(),
        page: 0,
        isLoading: true,
        isNextPageLoading: false,
      );
}
