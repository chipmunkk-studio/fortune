import 'package:json_annotation/json_annotation.dart';

part 'country_code_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class CountryCodeResponse {
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'name')
  final String name;

  CountryCodeResponse({
    required this.code,
    required this.name,
  });

  factory CountryCodeResponse.fromJson(Map<String, dynamic> json) => _$CountryCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CountryCodeResponseToJson(this);
}
