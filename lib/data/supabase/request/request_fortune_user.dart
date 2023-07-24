import 'package:json_annotation/json_annotation.dart';

part 'request_fortune_user.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class RequestFortuneUser {
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'nickname')
  final String? nickname;
  @JsonKey(name: 'profileImage')
  final String? profileImage;
  @JsonKey(name: 'ticket')
  final int? ticket;
  @JsonKey(name: 'marker_obtain_count')
  final int? markerObtainCount;
  @JsonKey(name: 'level')
  final int? level;

  RequestFortuneUser({
    this.phone,
    this.nickname,
    this.profileImage,
    this.ticket,
    this.markerObtainCount,
    this.level,
  });

  RequestFortuneUser.insert({
    required this.phone,
    required this.nickname,
    this.ticket = 0,
    this.markerObtainCount = 0,
    this.level = 1,
    this.profileImage = '',
  });

  factory RequestFortuneUser.fromJson(Map<String, dynamic> json) => _$RequestFortuneUserFromJson(json);

  Map<String, dynamic> toJson() => _$RequestFortuneUserToJson(this);
}
