import 'package:fortune/domain/supabase/entity/support/privacy_policy_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_policy_state.freezed.dart';

@freezed
class PrivacyPolicyState with _$PrivacyPolicyState {
  factory PrivacyPolicyState({
    required List<PrivacyPolicyEntity> items,
    required bool isLoading,
  }) = _PrivacyPolicyState;

  factory PrivacyPolicyState.initial() => PrivacyPolicyState(
        items: List.empty(),
        isLoading: true,
      );
}
