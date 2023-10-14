import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';

import 'web_login.dart';

@immutable
abstract class WebLoginEvent extends Equatable {}

class WebLoginInit extends WebLoginEvent {
  WebLoginInit();

  @override
  List<Object?> get props => [];
}

class WebLoginEmailInput extends WebLoginEvent {
  final String email;

  WebLoginEmailInput(this.email);

  @override
  List<Object?> get props => [];
}

class WebLoginBottomButtonClick extends WebLoginEvent {
  @override
  List<Object?> get props => [];
}

class WebLoginRequestVerifyCode extends WebLoginEvent {
  @override
  List<Object?> get props => [];
}

class WebLoginRequestCancelWithdrawal extends WebLoginEvent {
  @override
  List<Object?> get props => [];
}

class WebLoginRequestSelectCountry extends WebLoginEvent {
  CountryInfoEntity args;

  WebLoginRequestSelectCountry(this.args);

  @override
  List<Object?> get props => [];
}
