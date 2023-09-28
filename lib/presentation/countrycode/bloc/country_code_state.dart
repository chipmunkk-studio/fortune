import 'package:fortune/core/util/locale.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_code_state.freezed.dart';

@freezed
class CountryCodeState with _$CountryCodeState {
  factory CountryCodeState({
    required List<CountryInfoEntity> countries,
    required CountryCode selected,
  }) = _CountryCodeState;

  factory CountryCodeState.initial() {
    final currentCountryCode = getCurrentCountryCode();
    return CountryCodeState(
      countries: List.empty(),
      selected: CountryCode(
        code: currentCountryCode == 'KR' ? 82 : 1,
        name: currentCountryCode == 'KR' ? "대한민국" : "United States",
      ),
    );
  }
}

class CountryCode {
  int code;
  String name;

  CountryCode({
    required this.code,
    required this.name,
  });
}
