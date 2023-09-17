import 'package:fortune/domain/supabase/entity/common/faq_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'faqs_state.freezed.dart';

@freezed
class FaqsState with _$FaqsState {
  factory FaqsState({
    required List<FaqsEntity> items,
    required bool isLoading,
  }) = _FaqsState;

  factory FaqsState.initial() => FaqsState(
        items: List.empty(),
        isLoading: true,
      );
}
