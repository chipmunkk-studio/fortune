import 'package:json_annotation/json_annotation.dart';

part 'request_user_notices_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestUserNoticesUpdate {
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'user')
  final int userId;
  @JsonKey(name: 'ticket')
  final int ticket;

  RequestUserNoticesUpdate({
    required this.title,
    required this.content,
    required this.type,
    required this.userId,
    required this.ticket,
  });

  factory RequestUserNoticesUpdate.fromJson(Map<String, dynamic> json) => _$RequestUserNoticesUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestUserNoticesUpdateToJson(this);
}
