import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(ignoreUnannotated: false)
class UserNoticesEntity {
  final int id;
  final String title;
  final String content;
  final int ticket;
  final UserNoticeType type;
  final String createdAt;

  UserNoticesEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.ticket,
    required this.type,
    required this.createdAt,
  });
}
