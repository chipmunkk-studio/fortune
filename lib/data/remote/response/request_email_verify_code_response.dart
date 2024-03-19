import 'package:fortune/core/util/date.dart';
import 'package:fortune/domain/entity/request_email_verify_code_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_email_verify_code_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestEmailVerifyCodeResponse extends RequestEmailVerifyCodeEntity {
  @JsonKey(
    name: 'expireAt',
    fromJson: FortuneDateExtension.dateTimeFromIso8601String,
    toJson: FortuneDateExtension.dateTimeToIso8601String,
  )
  final DateTime? expireAt_;

  RequestEmailVerifyCodeResponse({
    required this.expireAt_,
  }) : super(expireAt: expireAt_ ?? DateTime.now());

  factory RequestEmailVerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestEmailVerifyCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestEmailVerifyCodeResponseToJson(this);
}
