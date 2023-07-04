import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/user_notices_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_notices_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class UserNoticesResponse extends UserNoticesEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'title')
  final String title_;
  @JsonKey(name: 'content')
  final String content_;
  @JsonKey(name: 'type')
  final String type_;
  @JsonKey(name: 'ticket')
  final int ticket_;
  @JsonKey(name: 'created_at')
  final String createdAt_;

  UserNoticesResponse({
    required this.id_,
    required this.title_,
    required this.content_,
    required this.ticket_,
    required this.type_,
    required this.createdAt_,
  }) : super(
          id: id_.toInt(),
          title: title_,
          content: content_,
          ticket: ticket_,
          type: getUserNoticeType(type_),
          createdAt: createdAt_,
        );

  factory UserNoticesResponse.fromJson(Map<String, dynamic> json) => _$UserNoticesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserNoticesResponseToJson(this);
}
