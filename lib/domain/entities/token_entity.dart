import 'package:json_annotation/json_annotation.dart';

part 'token_entity.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class TokenEntity {
  @JsonKey(name: 'accessToken')
  String accessToken;
  @JsonKey(name: 'refreshToken')
  String refreshToken;

  TokenEntity({required this.accessToken, required this.refreshToken});

  factory TokenEntity.fromJson(Map<String, dynamic> json) => _$TokenEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TokenEntityToJson(this);
}
