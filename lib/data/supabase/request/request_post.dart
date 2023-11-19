import 'package:json_annotation/json_annotation.dart';

part 'request_post.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class RequestPost {
  @JsonKey(name: 'users')
  final int? users;
  @JsonKey(name: 'content')
  final String? content;

  RequestPost({
    this.users,
    this.content,
  });

  // 회원가입.
  RequestPost.insert({
    required this.users,
    required this.content,
  });

  factory RequestPost.fromJson(Map<String, dynamic> json) => _$RequestPostFromJson(json);

  Map<String, dynamic> toJson() => _$RequestPostToJson(this);
}
