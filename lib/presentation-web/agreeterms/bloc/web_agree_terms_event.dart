import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';

@immutable
abstract class WebAgreeTermsEvent extends Equatable {}

class WebAgreeTermsInit extends WebAgreeTermsEvent {
  final String phoneNumber;

  WebAgreeTermsInit(
    this.phoneNumber,
  );

  @override
  List<Object?> get props => [];
}

class WebAgreeTermsTermClick extends WebAgreeTermsEvent {
  final AgreeTermsEntity terms;

  WebAgreeTermsTermClick(this.terms);

  @override
  List<Object?> get props => [];
}

class WebAgreeTermsAllClick extends WebAgreeTermsEvent {
  WebAgreeTermsAllClick();

  @override
  List<Object?> get props => [];
}
