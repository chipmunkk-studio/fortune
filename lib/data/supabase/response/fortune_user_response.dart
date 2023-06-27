import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_user_response.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class FortuneUserResponse extends FortuneUserEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'country_code')
  final String countryCode_;
  @JsonKey(name: 'phone')
  final String phone_;
  @JsonKey(name: 'nickname')
  final String nickname_;
  @JsonKey(name: 'profileImage')
  final String? profileImage_;
  @JsonKey(name: 'ticket')
  final int ticket_;
  @JsonKey(name: 'marker_obtain_count')
  final int markerObtainCount_;
  @JsonKey(name: 'level')
  final int level_;

  FortuneUserResponse({
    required this.id_,
    required this.phone_,
    required this.countryCode_,
    required this.nickname_,
    required this.profileImage_,
    required this.ticket_,
    required this.markerObtainCount_,
    required this.level_,
  }) : super(
          id: id_.toInt(),
          nickname: nickname_,
          phone: phone_,
          countryCode: countryCode_,
          ticket: ticket_,
          profileImage: profileImage_ ?? "",
          markerObtainCount: markerObtainCount_,
          level: level_,
        );

  factory FortuneUserResponse.fromJson(Map<String, dynamic> json) => _$FortuneUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneUserResponseToJson(this);
}
