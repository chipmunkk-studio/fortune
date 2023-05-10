import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/error/fortune_error_response.dart';

import '../../error/fortune_error_mapper.dart';

extension FortuneResponseMapper on Response {
  dynamic response() {
    dynamic decodedData;
    if (bodyBytes.isNotEmpty) {
      decodedData = jsonDecode(utf8.decode(bodyBytes));
    }
    return decodedData;
  }

  FortuneErrorResponse? errorResponse() {
    dynamic decodedData;
    if (bodyBytes.isNotEmpty) {
      decodedData = jsonDecode(utf8.decode(bodyBytes));
      return FortuneErrorResponse.fromJson(decodedData);
    }
    return decodedData;
  }

  dynamic toResponseData() {
    if (isSuccessful) {
      return response();
    } else {
      if (base.statusCode >= HttpStatus.internalServerError) {
        throw FortuneException(
          errorCode: FortuneErrorStatus.internalServerError,
          errorMessage: "${base.request?.url.path}",
        );
      }
      FortuneErrorResponse? errorResponse = this.errorResponse();
      throw FortuneException(
        errorCode: errorResponse?.code ?? FortuneErrorStatus.clientInternal,
        errorMessage: errorResponse?.message ?? "정의되지 않은 에러입니다.",
      );
    }
  }
}

extension FortuneDomainMapper<T> on Future<T> {
  Future<Either<FortuneFailure, T>> toRemoteDomainData(FortuneErrorMapper errorMapper) async {
    try {
      return Right(await this);
    } on FortuneException catch (e) {
      return errorMapper.mapAsLeft(e);
    }
  }

  Future<Either<FortuneFailure, T>> toLocalDomainData(FortuneErrorMapper errorMapper) async {
    try {
      return Right(await this);
    } catch (e) {
      return errorMapper.mapAsLeft(
        FortuneException(
          errorCode: FortuneErrorStatus.clientInternal,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
