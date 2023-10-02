import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:fortune/presentation/countrycode/country_code_page.dart';

import 'login.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class LoginInit extends LoginEvent {
  final LoginUserState loginUserState;

  LoginInit(
    this.loginUserState,
  );

  @override
  List<Object?> get props => [];
}

class LoginPhoneNumberInput extends LoginEvent {
  final String phoneNumber;

  LoginPhoneNumberInput(this.phoneNumber);

  @override
  List<Object?> get props => [];
}

class LoginBottomButtonClick extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginRequestVerifyCode extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginRequestCancelWithdrawal extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginRequestSelectCountry extends LoginEvent {
  CountryInfoEntity args;

  LoginRequestSelectCountry(this.args);

  @override
  List<Object?> get props => [];
}
