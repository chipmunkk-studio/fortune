import 'package:foresh_flutter/domain/supabase/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class UserResponse extends UserEntity {
  @JsonKey(name: 'phone')
  final String phone_;
  @JsonKey(name: 'nickname')
  final String nickname_;

  UserResponse({
    required this.phone_,
    required this.nickname_,
  }) : super(
          nickname: nickname_,
          phone: phone_,
        );

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
