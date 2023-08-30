import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_detail_state.freezed.dart';

@freezed
class TermsDetailState with _$TermsDetailState {
  factory TermsDetailState({
    required AgreeTermsEntity terms,
  }) = _TermsDetailState;

  factory TermsDetailState.initial([
    AgreeTermsEntity? terms,
  ]) =>
      TermsDetailState(
        terms: AgreeTermsEntity.empty,
      );
}
