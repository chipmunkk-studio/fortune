import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_code_state.freezed.dart';

@freezed
class CountryCodeState with _$CountryCodeState {
  factory CountryCodeState({
    required List<CountryInfoEntity> countries,
    required CountryInfoEntity selected,
    required bool isLoading,
  }) = _CountryCodeState;

  factory CountryCodeState.initial() {
    return CountryCodeState(
      countries: List.empty(),
      selected: CountryInfoEntity.empty(),
      isLoading: true,
    );
  }
}
