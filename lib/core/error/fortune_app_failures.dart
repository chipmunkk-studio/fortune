import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'failure/auth_failure.dart';
import 'failure/common_failure.dart';
import 'failure/custom_failure.dart';
import 'failure/network_failure.dart';
import 'failure/unknown_failure.dart';

class FortuneException {
  final String? errorCode;
  final String? errorMessage;

  FortuneException({
    required this.errorCode,
    required this.errorMessage,
  });
}

abstract class FortuneFailureDeprecated extends Equatable {
  final String? code;
  final String? message;
  final String? description;

  const FortuneFailureDeprecated({
    this.code,
    this.message,
    this.description,
  }) : super();

  FortuneFailureDeprecated copyWith({
    String? code,
    String? message,
    String? description,
  });

  @override
  String toString() => "code:$code\nmessage:$message\ndescription:$description";
}

extension FortuneExceptionX on Exception {
  FortuneFailureDeprecated handleException() {
    if (this is PostgrestException) {
      final postgrestException = this as PostgrestException;
      if (postgrestException.message.contains("Token") ||
          postgrestException.message.contains("JWT") ||
          postgrestException.message.contains("JWSError") ||
          postgrestException.message.contains("Invalid API")) {
        // 크래실리틱스 전송.
        FirebaseCrashlytics.instance.recordError(
          this,
          StackTrace.current,
          reason: "[${postgrestException.code}] ${postgrestException.message}",
          fatal: true,
        );
        return AuthFailure(
          errorCode: postgrestException.code,
          errorMessage: postgrestException.message,
        );
      } else {
        return CommonFailure(
          errorMessage: postgrestException.message,
        );
      }
    } else if (this is AuthException) {
      final authException = this as AuthException;
      // 크래실리틱스 전송.
      FirebaseCrashlytics.instance.recordError(
        this,
        StackTrace.current,
        reason: "[${authException.statusCode}] ${authException.message}",
        fatal: true,
      );
      return AuthFailure(
        errorCode: authException.statusCode,
        errorMessage: authException.message,
      );
    } else if (this is HttpException || this is SocketException || this is TimeoutException) {
      return NetworkFailure(
        errorMessage: FortuneTr.confirmNetworkConnection,
      ); // your own exception for handling core errors
    } else {
      return UnknownFailure(errorMessage: toString());
    }
  }
}

extension FortuneFailureX on FortuneFailureDeprecated {
  FortuneFailureDeprecated handleFortuneFailure({
    String? description,
  }) {
    if (this is CustomFailure) {
      return this;
    }

    FortuneLogger.error(code: code, message: message, description: description);

    return copyWith(
      description: description ?? FortuneTr.msgUpdateUserInfo,
    );
  }

  Map<String, dynamic> toJsonMap() {
    if (this is CommonFailure) return (this as CommonFailure).toJson();
    if (this is AuthFailure) return (this as AuthFailure).toJson();
    if (this is CustomFailure) return (this as CustomFailure).toJson();
    if (this is NetworkFailure) return (this as NetworkFailure).toJson();
    if (this is UnknownFailure) return (this as UnknownFailure).toJson();

    return {};
  }
}
