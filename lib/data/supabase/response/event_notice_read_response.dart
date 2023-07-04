import 'package:foresh_flutter/domain/supabase/entity/event_notice_read_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_notice_read_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class EventNoticeReadResponse extends EventNoticeReadEntity {
  @JsonKey(name: 'notice')
  final double notice_;
  @JsonKey(name: 'user')
  final double user_;

  EventNoticeReadResponse({
    required this.notice_,
    required this.user_,
  }) : super(
          notice: notice_.toInt(),
          user: user_.toInt(),
        );

  factory EventNoticeReadResponse.fromJson(Map<String, dynamic> json) => _$EventNoticeReadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventNoticeReadResponseToJson(this);
}
