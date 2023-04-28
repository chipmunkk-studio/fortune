import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';


@immutable
abstract class PhoneNumberSideEffect extends Equatable {}

class PhoneNumberError extends PhoneNumberSideEffect {
  final FortuneFailure error;

  PhoneNumberError(this.error);

  @override
  List<Object?> get props => [];
}
