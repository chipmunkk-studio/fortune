import 'package:foresh_flutter/data/supabase/response/event_notice_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'one_signal_notification_response.g.dart';

// https://supabase.com/docs/guides/integrations/onesignal
@JsonSerializable(ignoreUnannotated: false)
class OneSignalNotificationResponse {
  @JsonKey(name: 'custom')
  final OneSignalNotificationCustomResponse? custom;
  @JsonKey(name: 'alert')
  final String? content;
  @JsonKey(name: 'title')
  final String? title;

  OneSignalNotificationResponse({
    this.custom,
    this.content,
    this.title,
  });

  factory OneSignalNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$OneSignalNotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OneSignalNotificationResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class OneSignalNotificationCustomResponse {
  @JsonKey(name: 'a')
  final EventNoticeResponse? entity;

  OneSignalNotificationCustomResponse({this.entity});

  factory OneSignalNotificationCustomResponse.fromJson(Map<String, dynamic> json) =>
      _$OneSignalNotificationCustomResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OneSignalNotificationCustomResponseToJson(this);
}
