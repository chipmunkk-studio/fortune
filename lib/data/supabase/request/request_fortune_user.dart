import 'package:json_annotation/json_annotation.dart';

part 'request_fortune_user.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class RequestFortuneUser {
  @JsonKey(name: 'email')
  final String? email;
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
  @JsonKey(name: 'push_token')
  final String? pushToken;
  @JsonKey(name: 'is_withdrawal')
  final bool? isWithdrawal;
  @JsonKey(name: 'withdrawal_at')
  final String? withdrawalAt;

  RequestFortuneUser({
    this.email,
    this.nickname,
    this.profileImage,
    this.ticket,
    this.markerObtainCount,
    this.pushToken,
    this.level,
    this.isWithdrawal,
    this.withdrawalAt,
  });

  // 회원가입.
  RequestFortuneUser.insert({
    required this.email,
    required this.nickname,
    required this.pushToken,
    this.ticket = 3,
    this.markerObtainCount = 0,
    this.level = 1,
    this.profileImage = '',
    this.isWithdrawal = false,
    this.withdrawalAt,
  });

  factory RequestFortuneUser.fromJson(Map<String, dynamic> json) => _$RequestFortuneUserFromJson(json);

  Map<String, dynamic> toJson() => _$RequestFortuneUserToJson(this);
}
