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

  static String makeWebUrl({
    String? url,
    FortuneWebCommand? entity,
    Map<String, dynamic>? queryParams,
  }) {
    String paramUrl = url ?? baseUrl;
    Uri uri = Uri.parse(paramUrl);

    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    Uri finalUri = Uri.parse(paramUrl.toString());

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

requestWebUrl({
  String? paramUrl,
  FortuneWebCommand? entity,
  Map<String, dynamic>? queryParams,
}) async {
  final url = FortuneWebExtension.makeWebUrl(
    url: paramUrl,
    entity: entity,
    queryParams: queryParams,
  );
  final parsedUri = Uri.parse(url);

  if (await canLaunchUrl(parsedUri)) {
    final sourceIsApp = serviceLocator<Environment>().source == 'app';

    if (sourceIsApp || (entity == null && !sourceIsApp)) {
      await launchUrl(parsedUri);
    }
  } else {
    FortuneLogger.error(message: 'Cannot Routing :: $url');
  }
}
