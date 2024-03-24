import 'package:fortune/domain/entity/user_token_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_token_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class UserTokenResponse extends UserTokenEntity {
  @JsonKey(name: 'access_token')
  final String? accessToken_;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken_;

  UserTokenResponse({
    this.accessToken_,
    this.refreshToken_,
  }) : super(
          accessToken: accessToken_ ?? '',
          refreshToken: refreshToken_ ?? '',
        );

  factory UserTokenResponse.fromJson(Map<String, dynamic> json) => _$UserTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserTokenResponseToJson(this);
}
