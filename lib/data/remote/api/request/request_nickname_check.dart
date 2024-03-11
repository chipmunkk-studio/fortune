import 'package:json_annotation/json_annotation.dart';

part 'request_nickname_check.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class RequestNicknameCheck {
  @JsonKey(name: 'nickname')
  String nickname;

  RequestNicknameCheck({required this.nickname});

  factory RequestNicknameCheck.fromJson(Map<String, dynamic> json) => _$RequestNicknameCheckFromJson(json);

  Map<String, dynamic> toJson() => _$RequestNicknameCheckToJson(this);
}
