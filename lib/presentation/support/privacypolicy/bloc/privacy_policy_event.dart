import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class PrivacyPolicyEvent extends Equatable {}

class PrivacyPolicyInit extends PrivacyPolicyEvent {
  PrivacyPolicyInit();

  @override
  List<Object?> get props => [];
}

class PrivacyPolicyNextPage extends PrivacyPolicyEvent {
  PrivacyPolicyNextPage();

  @override
  List<Object?> get props => [];
}

class PrivacyPolicyNextPageGetContent extends PrivacyPolicyEvent {
  PrivacyPolicyNextPageGetContent();

  @override
  List<Object?> get props => [];
}
