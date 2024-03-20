import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class CountryCodeSideEffect extends Equatable {}

class CountryCodeError extends CountryCodeSideEffect {
  final FortuneFailureDeprecated error;

  CountryCodeError(this.error);

  @override
  List<Object?> get props => [];
}

class CountryCodeScrollSelected extends CountryCodeSideEffect {
  final int index;

  CountryCodeScrollSelected(this.index);

  @override
  List<Object?> get props => [];
}
