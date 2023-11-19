import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_entity.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class PostEntity {
  final int id;
  final FortuneUserEntity users;
  final String content;
  final String createdAt;

  PostEntity({
    required this.id,
    required this.users,
    required this.content,
    required this.createdAt,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) => _$PostEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PostEntityToJson(this);
}
