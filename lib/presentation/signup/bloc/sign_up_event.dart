import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SignUpEvent extends Equatable {}

class SignUpInit extends SignUpEvent {
  final String? phoneNumber;
  final String? countryCode;

  SignUpInit(this.phoneNumber, this.countryCode);

  @override
  List<Object?> get props => [];
}

class SignUpNickNameInput extends SignUpEvent {
  final String nickname;

  SignUpNickNameInput(this.nickname);

  @override
  List<Object?> get props => [];
}

class SignUpCheckNickname extends SignUpEvent {
  SignUpCheckNickname();

  @override
  List<Object?> get props => [];
}

class SignUpProfileChange extends SignUpEvent {
  final String profileImage;

  SignUpProfileChange(this.profileImage);

  @override
  List<Object?> get props => [];
}

class SignUpRequest extends SignUpEvent {
  SignUpRequest();

  @override
  List<Object?> get props => [];
}

class SignUpRequestStorageAuth extends SignUpEvent {
  SignUpRequestStorageAuth();

  @override
  List<Object?> get props => [];
}

class SignUpNicknameClear extends SignUpEvent {
  SignUpNicknameClear();

  @override
  List<Object?> get props => [];
}

