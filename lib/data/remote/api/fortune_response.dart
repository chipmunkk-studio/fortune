import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:dartz/dartz.dart';
import 'package:fortune/data/error/fortune_error.dart';

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
  Future<T> toRemoteDomainData(FortuneErrorMapper errorMapper) async {
    try {
      return await this;
    } on FortuneException catch (e) {
      throw errorMapper.mapAsLeft(e);
    }
  }

  Future<Either<FortuneFailure, T>> toLocalDomainData(FortuneErrorMapper errorMapper) async {
    return Right(await this);
  }
}
