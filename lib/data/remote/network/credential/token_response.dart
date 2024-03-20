import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'token_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class TokenResponse extends Equatable {
  @JsonKey(name: 'accessToken')
  final String? accessToken;
  @JsonKey(name: 'refreshToken')
  final String? refreshToken;
  @JsonKey(name: 'signUpToken')
  final String? signUpToken;

  const TokenResponse({
    this.accessToken,
    this.refreshToken,
    this.signUpToken,
  }) : _displayToken = accessToken;

  final String? _displayToken;

  bool isAccessTokenExpired() => JwtDecoder.isExpired(accessToken ?? '');

  bool isRefreshTokenExpired() => JwtDecoder.isExpired(refreshToken ?? '');

  @override
  String toString() {
    return 'TokenResponse{accessToken: $_displayToken, refreshToken: $refreshToken, signUpToken:$signUpToken}';
  }

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
