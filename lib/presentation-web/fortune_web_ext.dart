import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command.dart';
import 'package:fortune/domain/supabase/entity/web/fortune_web_query_param.dart';
import 'package:fortune/env.dart';
import 'package:url_launcher/url_launcher.dart';

class FortuneWebResponse {
  final String routes;
  final FortuneWebCommand? data;
  final FortuneWebQueryParam? queryParams;

  FortuneWebResponse(
    this.routes, {
    this.data,
    this.queryParams,
  });
}

abstract class FortuneWebExtension {
  static const webMainUrl = "https://chipmunk-studio.com";
  static const webMainDebugUrl = "https://fortune-50ef2--develop-7ospx4vb.web.app";

  static FortuneWebResponse parseAndGetUrlWithQueryParam(String url) {
    try {
      final uri = Uri.parse(url);
      final dataStr = uri.queryParameters['data'];
      final queryParams = FortuneWebQueryParam.fromJson(
        Map.of(uri.queryParameters)..remove('data'),
      );
      final routes = uri.fragment;
      FortuneWebCommand? param;

      if (dataStr != null) {
        final decodedData = Uri.decodeComponent(dataStr);
        final jsonMap = jsonDecode(decodedData);
        final WebCommand webCommand = (jsonMap['command'] as String).toWebCommand();
        param = _getParam(webCommand, jsonMap);
      }

      return FortuneWebResponse(
        routes,
        data: param,
        queryParams: queryParams,
      );
    } catch (e) {
      FortuneLogger.error(message: e.toString());
      rethrow;
    }
  }

  static String makeWebUrl({
    String route = '',
    FortuneWebCommand? entity,
    Map<String, dynamic>? queryParams,
  }) {
    final uri = Uri.parse("${getMainWebUrl(queryParams: queryParams)}#$route");

    if (entity != null) {
      final content = Uri.encodeComponent(jsonEncode(entity.toJson()));

      // 기존의 쿼리 파라미터와 새로운 파라미터를 결합
      final combinedQueryParams = {
        ...uri.queryParameters, // Spread operator를 사용하여 기존의 쿼리 파라미터를 추가
        'data': content,
      };

      final finalUri = uri.replace(queryParameters: combinedQueryParams);
      return finalUri.toString();
    }

    return uri.toString();
  }

  static String getMainWebUrl({Map<String, dynamic>? queryParams}) {
    String baseUrl = kReleaseMode ? webMainUrl : webMainDebugUrl;
    var uri = Uri.parse(baseUrl);
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
    return uri.toString();
  }

  static FortuneWebCommand? _getParam(WebCommand webCommand, dynamic jsonMap) {
    switch (webCommand) {
      case WebCommand.close:
        return FortuneWebCommand.fromJson(jsonMap);
      default:
        return null;
    }
  }
}

launchWebRoutes(
  String route, {
  FortuneWebCommand? entity,
  Map<String, dynamic>? queryParams,
}) async {
  final url = FortuneWebExtension.makeWebUrl(
    route: route,
    entity: entity,
    queryParams: queryParams,
  );
  final parsedUri = Uri.parse(url);

  if (await canLaunchUrl(parsedUri)) {
    // entity가 null인 경우 > 웹에서 웹으로 보내는 url임.
    // source가 app인 경우 앱에서 실행된 웹임.
    if (entity == null || serviceLocator<Environment>().source == 'app') {
      await launchUrl(parsedUri);
    }
  } else {
    FortuneLogger.error(message: 'Cannot Routing :: $url');
  }
}
