import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'token_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class TokenResponse extends Equatable {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  const TokenResponse({
    this.accessToken = '',
    this.refreshToken = '',
  }) : _displayToken = accessToken;

  factory TokenResponse.initial() => const TokenResponse();

  final String? _displayToken;

  bool isAccessTokenExpired() => JwtDecoder.isExpired(accessToken);

  bool isRefreshTokenExpired() => JwtDecoder.isExpired(refreshToken);

  @override
  String toString() {
    return 'TokenResponse{accessToken: $_displayToken, refreshToken: $refreshToken }';
  }

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
