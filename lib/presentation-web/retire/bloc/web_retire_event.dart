import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';

@immutable
abstract class WebRetireEvent extends Equatable {}

class WebRetireInit extends WebRetireEvent {
  WebRetireInit();

  @override
  List<Object?> get props => [];
}

class WebRetireEmailInput extends WebRetireEvent {
  final String email;

  WebRetireEmailInput(this.email);

  @override
  List<Object?> get props => [];
}

class WebRetireBottomButtonClick extends WebRetireEvent {
  @override
  List<Object?> get props => [];
}

class WebRetireRequestVerifyCode extends WebRetireEvent {
  @override
  List<Object?> get props => [];
}

class WebRetireRequestSelectCountry extends WebRetireEvent {
  CountryInfoEntity args;

  WebRetireRequestSelectCountry(this.args);

  @override
  List<Object?> get props => [];
}
