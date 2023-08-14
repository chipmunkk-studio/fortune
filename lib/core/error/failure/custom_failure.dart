import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custom_failure.g.dart';

/// 커스텀 에러.
@JsonSerializable(ignoreUnannotated: false)
class CustomFailure extends FortuneFailure {
  @JsonKey(name: 'errorDescription')
  final String? errorDescription;

  const CustomFailure({
    this.errorDescription,
  }) : super(
          message: errorDescription,
        );

  @override
  List<Object?> get props => [code, message, description];

  @override
  CustomFailure copyWith({
    String? code,
    String? message,
    String? description,
  }) {
    return CustomFailure(
      errorDescription: description ?? errorDescription,
    );
  }

  factory CustomFailure.fromJson(Map<String, dynamic> json) => _$CustomFailureFromJson(json);

  Map<String, dynamic> toJson() => _$CustomFailureToJson(this);
}
