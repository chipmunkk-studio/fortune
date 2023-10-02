import 'package:fortune/core/util/locale.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country_info_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class CountryInfoResponse extends CountryInfoEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'en_name')
  final String? enName_;
  @JsonKey(name: 'iso2')
  final String? iso2_;
  @JsonKey(name: 'iso3')
  final String? iso3_;
  @JsonKey(name: 'phone_code')
  final int? phoneCode_;
  @JsonKey(name: 'kr_name')
  final String? krName_;

  CountryInfoResponse({
    required this.id_,
    this.enName_,
    this.iso2_,
    this.iso3_,
    this.phoneCode_,
    this.krName_,
  }) : super(
          id: id_.toInt(),
          name: getLocaleContent(en: enName_ ?? '', kr: krName_ ?? ''),
          iso2: iso2_ ?? '',
          iso3: iso3_ ?? '',
          phoneCode: phoneCode_ ?? -1,
        );

  factory CountryInfoResponse.fromJson(Map<String, dynamic> json) => _$CountryInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CountryInfoResponseToJson(this);
}
