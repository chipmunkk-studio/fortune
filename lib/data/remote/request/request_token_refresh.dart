import 'package:json_annotation/json_annotation.dart';

part 'request_token_refresh.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestTokenRefresh {
  @JsonKey(name: 'token')
  final String token;

  RequestTokenRefresh({
    required this.token,
  });

  factory RequestTokenRefresh.fromJson(Map<String, dynamic> json) => _$RequestTokenRefreshFromJson(json);

  Map<String, dynamic> toJson() => _$RequestTokenRefreshToJson(this);
}
