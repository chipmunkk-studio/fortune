import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command.dart';
import 'package:fortune/domain/supabase/entity/web/fortune_web_query_param.dart';
import 'package:fortune/env.dart';
import 'package:url_launcher/url_launcher.dart';

class FortuneWebResponse {
  final FortuneWebCommand? data;
  final FortuneWebQueryParam? queryParams;

  FortuneWebResponse({
    this.data,
    this.queryParams,
  });
}

abstract class FortuneWebExtension {
  static const webMainUrl = "https://chipmunk-studio.com";
  static const webMainDebugUrl = "https://fortune-50ef2--develop-7ospx4vb.web.app";

  static String baseUrl = kReleaseMode ? webMainUrl : webMainDebugUrl;

  static FortuneWebResponse parseAndGetUrlWithQueryParam(String url) {
    try {
      final uri = Uri.parse(url);
      final dataStr = uri.queryParameters['data'];
      final queryParams = FortuneWebQueryParam.fromJson(
        Map.of(uri.queryParameters)..remove('data'),
      );
      FortuneWebCommand? param;

      if (dataStr != null) {
        final decodedData = Uri.decodeComponent(dataStr);
        final jsonMap = jsonDecode(decodedData);
        final WebCommand webCommand = (jsonMap['command'] as String).toWebCommand();
        param = _getParam(webCommand, jsonMap);
      }

      return FortuneWebResponse(
        data: param,
        queryParams: queryParams,
      );
    } catch (e) {
      FortuneLogger.error(message: e.toString());
      rethrow;
    }
  }

  static String makeRouteUrl({
    String? url,
    String route = '',
    FortuneWebCommand? entity,
    Map<String, dynamic>? queryParams,
  }) {
    String paramUrl = url ?? baseUrl;
    Uri uri = Uri.parse(paramUrl);

    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    Uri finalUri = Uri.parse("${uri.toString()}#$route");

    if (entity != null) {
      final content = Uri.encodeComponent(jsonEncode(entity.toJson()));
      final combinedQueryParams = {
        ...finalUri.queryParameters,
        'data': content,
      };
      finalUri = finalUri.replace(queryParameters: combinedQueryParams);
    }

    return finalUri.toString();
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

launchWebRoutes({
  FortuneWebCommand? entity,
  Map<String, dynamic>? queryParams,
}) async {
  final url = FortuneWebExtension.makeRouteUrl(
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
