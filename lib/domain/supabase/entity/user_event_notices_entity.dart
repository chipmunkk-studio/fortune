import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(ignoreUnannotated: false)
class UserEventNoticesEntity {
  final int id;
  final String title;
  final String content;
  final String eventType;
  final String noticeType;
  final String createdAt;

  UserEventNoticesEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.eventType,
    required this.noticeType,
    required this.createdAt,
  });
}
