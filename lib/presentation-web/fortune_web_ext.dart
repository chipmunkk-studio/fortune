import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command_close.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command_new_page.dart';
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
        param = _getCommandEntity(webCommand, jsonMap);
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
    Uri uri = Uri.parse(url ?? baseUrl);

    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    Uri finalUri = Uri.parse(uri.toString());

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

  static FortuneWebCommand? _getCommandEntity(WebCommand webCommand, dynamic jsonMap) {
    switch (webCommand) {
      case WebCommand.close:
        return FortuneWebCommandClose.fromJson(jsonMap);
      case WebCommand.newWebPage:
        return FortuneWebCommandNewPage.fromJson(jsonMap);
      default:
        return null;
    }
  }
}

// 웹에서 새로운 창을 띄울때 paramUrl을 사용하면됨.
// 앱에서는 main url말고, url 랜딩이 막혀있음.
requestWebUrl({
  String? paramUrl,
  FortuneWebCommand? command,
  Map<String, dynamic>? queryParams,
}) async {
  final environment = serviceLocator<Environment>();
  // 앱안에서 실행된 웹인지.
  final sourceIsApp = environment.source == 'app';
  final shouldUseNewPageUrl = command is FortuneWebCommandNewPage && !sourceIsApp;

  final targetUrl = shouldUseNewPageUrl ? command.url : paramUrl;
  final url = FortuneWebExtension.makeWebUrl(
    url: targetUrl,
    entity: command,
    queryParams: queryParams,
  );

  final parsedUri = Uri.parse(url);

  if (await canLaunchUrl(parsedUri)) {
    final shouldLaunch = sourceIsApp || (command == null || shouldUseNewPageUrl);
    if (shouldLaunch) {
      await launchUrl(parsedUri);
    }
  } else {
    FortuneLogger.error(message: 'Cannot Routing :: $url');
  }
}
