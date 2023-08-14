import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:json_annotation/json_annotation.dart';

part 'network_failure.g.dart';

/// 네트워크 에러.
@JsonSerializable(ignoreUnannotated: false)
class NetworkFailure extends FortuneFailure {
  @JsonKey(name: 'errorCode')
  final String? errorCode;
  @JsonKey(name: 'errorMessage')
  final String? errorMessage;
  @JsonKey(name: 'errorDescription')
  final String? errorDescription;

  const NetworkFailure({
    this.errorCode = '400',
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
  NetworkFailure copyWith({
    String? code,
    String? message,
    String? description,
  }) {
    return NetworkFailure(
      errorCode: code ?? errorCode,
      errorMessage: message ?? errorMessage,
      errorDescription: description ?? errorDescription,
    );
  }


  factory NetworkFailure.fromJson(Map<String, dynamic> json) => _$NetworkFailureFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkFailureToJson(this);
}
