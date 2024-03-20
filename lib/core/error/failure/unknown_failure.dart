


import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unknown_failure.g.dart';

/// 알 수 없는 에러.
@JsonSerializable(ignoreUnannotated: false)
class UnknownFailure extends FortuneFailureDeprecated {
  @JsonKey(name: 'errorCode')
  final String? errorCode;
  @JsonKey(name: 'errorMessage')
  final String? errorMessage;
  @JsonKey(name: 'errorDescription')
  final String? errorDescription;

  const UnknownFailure({
    this.errorCode = '999',
    this.errorMessage,
    this.errorDescription,
  }) : super(
    code: errorCode,
    message: errorMessage,
    description: errorDescription,
  );

  @override
  List<Object?> get props => [code, message, description];

  @override
  UnknownFailure copyWith({
    String? code,
    String? message,
    String? description,
  }) {
    return UnknownFailure(
      errorCode: code ?? errorCode,
      errorMessage: message ?? errorMessage,
      errorDescription: description ?? errorDescription,
    );
  }


  factory UnknownFailure.fromJson(Map<String, dynamic> json) => _$UnknownFailureFromJson(json);

  Map<String, dynamic> toJson() => _$UnknownFailureToJson(this);
}