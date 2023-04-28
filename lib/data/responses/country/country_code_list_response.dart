import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/country_code_entity.dart';
import 'country_code_response.dart';

part 'country_code_list_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class CountryCodeListResponse extends CountryCodeListEntity {
  @JsonKey(name: 'countries')
  final List<CountryCodeResponse>? countries_;

  CountryCodeListResponse({
    required this.countries_,
  }) : super(
          countries: countries_
                  ?.map(
                    (e) => CountryCode(
                      code: e.code,
                      name: e.name,
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory CountryCodeListResponse.fromJson(Map<String, dynamic> json) => _$CountryCodeListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CountryCodeListResponseToJson(this);
}
