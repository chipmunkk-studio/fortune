import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_agree_terms_state.freezed.dart';

@freezed
class WebAgreeTermsState with _$WebAgreeTermsState {
  factory WebAgreeTermsState({
    required String phoneNumber,
    required List<AgreeTermsEntity> agreeTerms,
  }) = _WebAgreeTermsState;

  factory WebAgreeTermsState.initial([
    List<AgreeTermsEntity>? agreeTerms,
    String? phoneNumber,
  ]) =>
      WebAgreeTermsState(
        phoneNumber: phoneNumber ?? "",
        agreeTerms: agreeTerms ?? List.empty(),
      );
}
