import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'token_response.dart';

part 'user_credential.g.dart';

@JsonSerializable()
@immutable
class UserCredential extends Equatable {
  final TokenResponse? token;

  const UserCredential(
    this.token,
  );

  factory UserCredential.fromJson(Map<String, dynamic> json) => _$UserCredentialFromJson(json);

  factory UserCredential.initial() => const UserCredential(null);

  Map<String, dynamic> toJson() => _$UserCredentialToJson(this);

  UserCredential copy({
    int? id,
    TokenResponse? token,
  }) =>
      UserCredential(
        token ?? this.token,
      );

  @override
  List<Object?> get props => [
        token,
      ];

  @override
  String toString() => 'UserCredential{' 'token: $token' '}';
}
