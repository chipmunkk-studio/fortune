import 'package:foresh_flutter/domain/supabase/entity/user_event_notices_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_event_notices_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class UserEventNoticesResponse extends UserEventNoticesEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'title')
  final String title_;
  @JsonKey(name: 'content')
  final String content_;
  @JsonKey(name: 'event_type')
  final String eventType_;
  @JsonKey(name: 'notice_type')
  final String noticeType_;
  @JsonKey(name: 'created_at')
  final String createdAt_;

  UserEventNoticesResponse({
    required this.id_,
    required this.title_,
    required this.content_,
    required this.eventType_,
    required this.noticeType_,
    required this.createdAt_,
  }) : super(
          id: id_.toInt(),
          title: title_,
          content: content_,
          eventType: eventType_,
          noticeType: noticeType_,
          createdAt: createdAt_,
        );

  factory UserEventNoticesResponse.fromJson(Map<String, dynamic> json) => _$UserEventNoticesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserEventNoticesResponseToJson(this);
}
