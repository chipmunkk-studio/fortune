import 'package:fortune/core/util/date.dart';
import 'package:fortune/domain/entity/email_verify_code_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_verify_code_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class EmailVerifyCodeResponse extends EmailVerifyCodeEntity {
  @JsonKey(
    name: 'expire_at',
    fromJson: FortuneDateExtension.dateTimeFromIso8601String,
    toJson: FortuneDateExtension.dateTimeToIso8601String,
  )
  final DateTime? expireAt_;

  EmailVerifyCodeResponse({
    required this.expireAt_,
  }) : super(expireAt: expireAt_ ?? DateTime.now());

  factory EmailVerifyCodeResponse.fromJson(Map<String, dynamic> json) => _$EmailVerifyCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmailVerifyCodeResponseToJson(this);
}
