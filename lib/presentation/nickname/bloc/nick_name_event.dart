import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NickNameEvent extends Equatable {}

class NickNameInit extends NickNameEvent {
  NickNameInit();

  @override
  List<Object?> get props => [];
}

class NickNameUpdateProfile extends NickNameEvent {
  final String filePath;

  NickNameUpdateProfile(this.filePath);

  @override
  List<Object?> get props => [];
}

class NickNameTextInput extends NickNameEvent {
  final String text;

  NickNameTextInput(this.text);

  @override
  List<Object?> get props => [];
}

class NickNameSignOut extends NickNameEvent {
  NickNameSignOut();

  @override
  List<Object?> get props => [];
}

class NickNameWithdrawal extends NickNameEvent {
  NickNameWithdrawal();

  @override
  List<Object?> get props => [];
}

class NickNameUpdateNickName extends NickNameEvent {
  NickNameUpdateNickName();

  @override
  List<Object?> get props => [];
}
