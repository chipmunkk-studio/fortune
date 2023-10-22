import 'package:fortune/core/message_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_user_response.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class FortuneUserResponse extends FortuneUserEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'email')
  final String? email_;
  @JsonKey(name: 'nickname')
  final String? nickname_;
  @JsonKey(name: 'profileImage')
  final String? profileImage_;
  @JsonKey(name: 'ticket')
  final int? ticket_;
  @JsonKey(name: 'marker_obtain_count')
  final int? markerObtainCount_;
  @JsonKey(name: 'level')
  final int? level_;
  @JsonKey(name: 'is_withdrawal')
  final bool? isWithdrawal_;
  @JsonKey(name: 'push_token')
  final String? pushToken_;
  @JsonKey(name: 'withdrawal_at')
  final String? withdrawalAt_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  FortuneUserResponse({
    required this.id_,
    required this.email_,
    required this.nickname_,
    required this.profileImage_,
    required this.ticket_,
    required this.markerObtainCount_,
    required this.pushToken_,
    required this.level_,
    required this.isWithdrawal_,
    required this.withdrawalAt_,
    required this.createdAt_,
  }) : super(
          id: id_.toInt(),
          nickname: nickname_ ?? FortuneTr.msgUnknownUser,
          email: email_ ?? '',
          ticket: ticket_ ?? 0,
          profileImage: profileImage_ ?? "",
          markerObtainCount: markerObtainCount_ ?? 0,
          level: level_ ?? 0,
          isWithdrawal: isWithdrawal_ ?? false,
          pushToken: pushToken_ ?? '',
          withdrawalAt: withdrawalAt_ ?? '',
          createdAt: createdAt_ ?? '',
        );

  factory FortuneUserResponse.fromJson(Map<String, dynamic> json) => _$FortuneUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneUserResponseToJson(this);
}
