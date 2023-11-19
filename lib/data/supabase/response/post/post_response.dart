import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/post/post_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_response.g.dart';

enum PostColumn {
  id,
  users,
  content,
  createdAt,
}

extension PostColumnExtension on PostColumn {
  String get name {
    switch (this) {
      case PostColumn.id:
        return 'id';
      case PostColumn.users:
        return 'users';
      case PostColumn.content:
        return 'content';
      case PostColumn.createdAt:
        return 'created_at';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class PostResponse extends PostEntity {
  @JsonKey(name: 'id')
  final int? id_;
  @JsonKey(name: 'users')
  final FortuneUserResponse? users_;
  @JsonKey(name: 'content')
  final String? content_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  PostResponse({
    this.id_,
    this.users_,
    this.content_,
    this.createdAt_,
  }) : super(
          id: id_ ?? 0,
          users: users_ ?? FortuneUserEntity.empty(),
          content: content_ ?? '',
          createdAt: createdAt_ ?? '',
        );

  @override
  factory PostResponse.fromJson(Map<String, dynamic> json) => _$PostResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}
