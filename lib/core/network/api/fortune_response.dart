import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:dartz/dartz.dart';
import 'package:fortune/core/error2/fortune_app_failures.dart';
import 'package:fortune/core/error2/fortune_error_mapper.dart';
import 'package:fortune/core/error2/fortune_error_response.dart';

extension FortuneResponseMapper on Response {
  dynamic response() {
    dynamic decodedData;
    if (bodyBytes.isNotEmpty) {
      decodedData = jsonDecode(utf8.decode(bodyBytes));
    }
    return decodedData;
  }

  FortuneErrorResponse? toErrorResponse() {
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
      FortuneErrorResponse? errorResponse = toErrorResponse();
      throw FortuneException(
        code: errorResponse?.code ?? base.statusCode,
        message: errorResponse?.message ?? error.toString(),
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
    return Right(await this);
  }
}
