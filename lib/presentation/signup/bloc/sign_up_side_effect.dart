import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/fortune_app_failures.dart';

@immutable
abstract class SignUpSideEffect extends Equatable {}

class SignUpNickNameError extends SignUpSideEffect {
  final FortuneFailure error;

  SignUpNickNameError(this.error);

  @override
  List<Object?> get props => [];
}

class SignUpProfileError extends SignUpSideEffect {
  final FortuneFailure error;

  SignUpProfileError(this.error);

  @override
  List<Object?> get props => [];
}

class SignUpMoveNext extends SignUpSideEffect {
  final SignUpMoveNextPage page;

  SignUpMoveNext(this.page);

  @override
  List<Object?> get props => [];
}


class SignUpShowRequestStorageAuthDialog extends SignUpSideEffect {

  SignUpShowRequestStorageAuthDialog();

  @override
  List<Object?> get props => [];
}

enum SignUpMoveNextPage {
  profile,
  complete,
}
