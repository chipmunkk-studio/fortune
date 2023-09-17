import 'package:fortune/domain/supabase/entity/country_code_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country_code_response.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class CountryCodeResponse extends CountryCodeEntity {
  @JsonKey(name: 'iso2')
  final String? iso2_;
  @JsonKey(name: 'iso3')
  final String? iso3_;
  @JsonKey(name: 'phone_code')
  final String? phoneCode_;
  @JsonKey(name: 'e_name')
  final String? eName_;
  @JsonKey(name: 'k_name')
  final String? kName_;

  const CountryCodeResponse({
    required this.iso2_,
    required this.iso3_,
    required this.phoneCode_,
    required this.eName_,
    required this.kName_,
  }) : super(
          iso2: iso2_ ?? "",
          iso3: iso3_ ?? "",
          phoneCode: phoneCode_ ?? "",
          eName: eName_ ?? "",
          kName: kName_ ?? "",
        );

  factory CountryCodeResponse.fromJson(Map<String, dynamic> json) => _$CountryCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CountryCodeResponseToJson(this);
}
