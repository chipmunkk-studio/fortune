import 'dart:io';

import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:json_annotation/json_annotation.dart';

part 'common_failure.g.dart';

/// 공통 에러.
@JsonSerializable(ignoreUnannotated: false)
class CommonFailure extends FortuneFailure {
  @JsonKey(name: 'errorMessage')
  final String? errorMessage;
  @JsonKey(name: 'errorDescription')
  final String? errorDescription;

  CommonFailure({
    this.errorMessage,
    this.errorDescription,
  }) : super(
          code: HttpStatus.badRequest.toString(),
          message: errorMessage,
          description: errorDescription,
        );

  @override
  List<Object?> get props => [code, message, description];

  @override
  CommonFailure copyWith({
    String? code,
    String? message,
    String? description,
  }) {
    return CommonFailure(
      errorMessage: message ?? errorMessage,
      errorDescription: description ?? errorDescription,
    );
  }

  factory CommonFailure.fromJson(Map<String, dynamic> json) => _$CommonFailureFromJson(json);

  Map<String, dynamic> toJson() => _$CommonFailureToJson(this);
}
