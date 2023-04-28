import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CountryCodeEvent extends Equatable {}

class CountryCodeInit extends CountryCodeEvent {
  final String? code;
  final String? name;

  CountryCodeInit({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [];
}
