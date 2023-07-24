import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agree_terms_state.freezed.dart';

@freezed
class AgreeTermsState with _$AgreeTermsState {
  factory AgreeTermsState({
    required String phoneNumber,
    required List<AgreeTermsEntity> agreeTerms,
  }) = _AgreeTermsState;

  factory AgreeTermsState.initial([
    List<AgreeTermsEntity>? agreeTerms,
    String? phoneNumber,
  ]) =>
      AgreeTermsState(
        phoneNumber: phoneNumber ?? "",
        agreeTerms: agreeTerms ?? List.empty(),
      );
}
