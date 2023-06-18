import 'package:json_annotation/json_annotation.dart';

part 'one_signal_notification_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class OneSignalNotificationResponse {
  @JsonKey(name: 'custom')
  final OneSignalNotificationCustom? custom;
  @JsonKey(name: 'alert')
  final String? alert;
  @JsonKey(name: 'title')
  final String? title;

  OneSignalNotificationResponse({
    this.custom,
    this.alert,
    this.title,
  });

  factory OneSignalNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$OneSignalNotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OneSignalNotificationResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class OneSignalNotificationCustom {
  @JsonKey(name: 'a')
  final OneSignalNotificationCustomEntity? entity;

  OneSignalNotificationCustom({this.entity});

  factory OneSignalNotificationCustom.fromJson(Map<String, dynamic> json) => _$OneSignalNotificationCustomFromJson(json);

  Map<String, dynamic> toJson() => _$OneSignalNotificationCustomToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class OneSignalNotificationCustomEntity {
  @JsonKey(name: 'landing')
  final String? landing;
  @JsonKey(name: 'ticket')
  final int? ticket;

  OneSignalNotificationCustomEntity({
    this.landing,
    this.ticket,
  });

  factory OneSignalNotificationCustomEntity.fromJson(Map<String, dynamic> json) => _$OneSignalNotificationCustomEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OneSignalNotificationCustomEntityToJson(this);
}
