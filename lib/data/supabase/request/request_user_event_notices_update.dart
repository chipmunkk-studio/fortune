import 'package:json_annotation/json_annotation.dart';

part 'request_user_event_notices_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestEventNoticesUpdate {
  @JsonKey(name: 'title')
  final String title_;
  @JsonKey(name: 'content')
  final String content_;
  @JsonKey(name: 'event_type')
  final String eventType_;
  @JsonKey(name: 'notice_type')
  final String noticeType_;

  RequestEventNoticesUpdate({
    required this.title_,
    required this.content_,
    required this.eventType_,
    required this.noticeType_,
  });

  factory RequestEventNoticesUpdate.fromJson(Map<String, dynamic> json) => _$RequestEventNoticesUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestEventNoticesUpdateToJson(this);
}
