import 'package:fortune/core/message_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_user_response.g.dart';

enum UserColumn {
  id,
  email,
  nickname,
  markerObtainCount,
  ticket,
  profileImage,
  level,
  createdAt,
  withdrawalAt,
  isWithdrawal,
  pushToken,
}

extension UserColumnExtension on UserColumn {
  String get name {
    switch (this) {
      case UserColumn.id:
        return 'id';
      case UserColumn.email:
        return 'email';
      case UserColumn.nickname:
        return 'nickname';
      case UserColumn.markerObtainCount:
        return 'marker_obtain_count';
      case UserColumn.ticket:
        return 'ticket';
      case UserColumn.profileImage:
        return 'profileImage';
      case UserColumn.level:
        return 'level';
      case UserColumn.createdAt:
        return 'created_at';
      case UserColumn.withdrawalAt:
        return 'withdrawal_at';
      case UserColumn.isWithdrawal:
        return 'is_withdrawal';
      case UserColumn.pushToken:
        return 'push_token';
    }
  }
}

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class FortuneUserResponse extends FortuneUserEntity {
  @JsonKey(name: 'id')
  final double? id_;
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
          id: id_?.toInt() ?? -1,
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

  @override
  Map<String, dynamic> toJson() => _$FortuneUserResponseToJson(this);
}
