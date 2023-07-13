import 'package:json_annotation/json_annotation.dart';

part 'request_user_update.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class RequestFortuneUserUpdate {
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'nickname')
  final String? nickname;
  @JsonKey(name: 'country_code')
  final String? countryCode;
  @JsonKey(name: 'ticket')
  final int? ticket;
  @JsonKey(name: 'marker_obtain_count')
  final int? markerObtainCount;
  @JsonKey(name: 'level')
  final int? level;

  RequestFortuneUserUpdate({
    this.phone,
    this.nickname,
    this.ticket,
    this.countryCode,
    this.markerObtainCount,
    this.level,
  });


  RequestFortuneUserUpdate.insert({
    required this.phone,
    this.nickname,
    this.ticket,
    required this.countryCode,
    this.markerObtainCount,
    this.level,
  });

  factory RequestFortuneUserUpdate.fromJson(Map<String, dynamic> json) => _$RequestFortuneUserUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestFortuneUserUpdateToJson(this);
}
