import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';

@immutable
abstract class AgreeTermsEvent extends Equatable {}

class AgreeTermsInit extends AgreeTermsEvent {
  final String phoneNumber;

  AgreeTermsInit(
    this.phoneNumber,
  );

  @override
  List<Object?> get props => [];
}

class AgreeTermsTermClick extends AgreeTermsEvent {
  final AgreeTermsEntity terms;

  AgreeTermsTermClick(this.terms);

  @override
  List<Object?> get props => [];
}

class AgreeTermsAllClick extends AgreeTermsEvent {
  AgreeTermsAllClick();

  @override
  List<Object?> get props => [];
}
