import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/country_code_entity.dart';

part 'country_code_state.freezed.dart';

@freezed
class CountryCodeState with _$CountryCodeState {
  factory CountryCodeState({
    required List<CountryCode> countries,
    required CountryCode selected,
  }) = _CountryCodeState;

  factory CountryCodeState.initial() => CountryCodeState(
        countries: List.empty(),
        selected: const CountryCode(
          code: "+82",
          name: "대한민국",
        ),
      );
}
