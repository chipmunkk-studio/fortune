import 'package:json_annotation/json_annotation.dart';

part 'request_event_notice_read_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestEventNoticeReadUpdate {
  @JsonKey(name: 'notice')
  final int notice;
  @JsonKey(name: 'user')
  final int user;

  RequestEventNoticeReadUpdate({
    required this.notice,
    required this.user,
  });

  factory RequestEventNoticeReadUpdate.fromJson(Map<String, dynamic> json) =>
      _$RequestEventNoticeReadUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestEventNoticeReadUpdateToJson(this);
}
