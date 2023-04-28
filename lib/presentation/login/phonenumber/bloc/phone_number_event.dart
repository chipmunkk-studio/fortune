import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class PhoneNumberEvent extends Equatable {}

class PhoneNumberInit extends PhoneNumberEvent {
  final String? countryCode;
  final String? countryName;

  PhoneNumberInit(this.countryCode, this.countryName);

  @override
  List<Object?> get props => [];
}

class PhoneNumberInput extends PhoneNumberEvent {
  final String phoneNumber;

  PhoneNumberInput(this.phoneNumber);

  @override
  List<Object?> get props => [];
}

class PhoneNumberCancel extends PhoneNumberEvent {
  @override
  List<Object?> get props => [];
}

class PhoneNumberChangeCountryCode extends PhoneNumberEvent {
  final String countryCode;
  final String countryName;

  PhoneNumberChangeCountryCode(this.countryCode, this.countryName);

  @override
  List<Object?> get props => [];
}
