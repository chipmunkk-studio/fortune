import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';

@immutable
abstract class VerifyCodeEvent extends Equatable {}

class VerifyCodeInit extends VerifyCodeEvent {
  final String phoneNumber;
  final CountryInfoEntity countryInfoEntity;

  VerifyCodeInit({
    required this.phoneNumber,
    required this.countryInfoEntity,
  });

  @override
  List<Object?> get props => [];
}

class VerifyCodeCountdown extends VerifyCodeEvent {
  @override
  List<Object?> get props => [];
}

class VerifyCodeInput extends VerifyCodeEvent {
  final String verifyCode;
  final bool isFromListening;

  VerifyCodeInput({
    required this.verifyCode,
    this.isFromListening = false,
  });

  @override
  List<Object?> get props => [];
}

class VerifyConfirm extends VerifyCodeEvent {
  VerifyConfirm();

  @override
  List<Object?> get props => [];
}

class VerifyCodeRequestVerifyCode extends VerifyCodeEvent {
  VerifyCodeRequestVerifyCode();

  @override
  List<Object?> get props => [];
}
