import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:fortune/presentation/login/bloc/login_state.dart';

@immutable
abstract class WebVerifyCodeEvent extends Equatable {}

class WebVerifyCodeInit extends WebVerifyCodeEvent {
  final String email;
  final bool isRetire;

  WebVerifyCodeInit({
    required this.email,
    required this.isRetire,
  });

  @override
  List<Object?> get props => [];
}

class WebVerifyCodeCountdown extends WebVerifyCodeEvent {
  @override
  List<Object?> get props => [];
}

class WebVerifyCodeInput extends WebVerifyCodeEvent {
  final String verifyCode;
  final bool isFromListening;

  WebVerifyCodeInput({
    required this.verifyCode,
    this.isFromListening = false,
  });

  @override
  List<Object?> get props => [];
}

class WebVerifyConfirm extends WebVerifyCodeEvent {
  WebVerifyConfirm();

  @override
  List<Object?> get props => [];
}

class WebVerifyCodeRequestVerifyCode extends WebVerifyCodeEvent {
  WebVerifyCodeRequestVerifyCode();

  @override
  List<Object?> get props => [];
}
