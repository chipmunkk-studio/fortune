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
  final OneSignalNotificationCustomEntity? entity;

  OneSignalNotificationCustomResponse({this.entity});

  factory OneSignalNotificationCustomResponse.fromJson(Map<String, dynamic> json) => _$OneSignalNotificationCustomResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OneSignalNotificationCustomResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class OneSignalNotificationCustomEntity {
  @JsonKey(name: 'headings')
  final String? headings;
  @JsonKey(name: 'content')
  final String? content;
  @JsonKey(name: 'ticket')
  final int? ticket;
  @JsonKey(name: 'type')
  final String? type;
  @JsonKey(name: 'landingRoute')
  final String? landingRoute;
  @JsonKey(name: 'searchText')
  final String? searchText;
  @JsonKey(name: 'is_notify')
  final bool? isNotify;

  OneSignalNotificationCustomEntity({
    this.landingRoute,
    this.searchText,
    this.headings,
    this.content,
    this.type,
    this.ticket,
    this.isNotify,
  });

  factory OneSignalNotificationCustomEntity.fromJson(Map<String, dynamic> json) => _$OneSignalNotificationCustomEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OneSignalNotificationCustomEntityToJson(this);
}
