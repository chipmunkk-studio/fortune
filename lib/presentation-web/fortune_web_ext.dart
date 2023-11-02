import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/domain/supabase/entity/web/fortune_web_close_entity.dart';
import 'package:fortune/domain/supabase/entity/web/fortune_web_common_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class FortuneWebResponse {
  final String routes;
  final FortuneWebCommonEntity? data;

  FortuneWebResponse(
    this.routes, {
    this.data,
  });
}

abstract class FortuneWebExtension {
  static const webMainUrl = "https://chipmunk-studio.com/";
  static const webMainDebugUrl = "https://fortune-50ef2--develop-7ospx4vb.web.app/";

  static FortuneWebResponse parseAndGetUrlWithQueryParam(String url) {
    try {
      final uri = Uri.parse(url);
      final dataStr = uri.queryParameters['data'];
      final routes = uri.fragment;
      FortuneWebCommonEntity? param;

      if (dataStr != null) {
        final decodedData = Uri.decodeComponent(dataStr);
        final jsonMap = jsonDecode(decodedData);
        final WebCommand webCommand = (jsonMap['command'] as String).toWebCommand();

        switch (webCommand) {
          case WebCommand.close:
            param = FortuneWebCloseEntity.fromJson(jsonMap);
            break;
          default:
            param = null;
        }
      }

      return FortuneWebResponse(
        routes,
        data: param,
      );
    } catch (e) {
      FortuneLogger.error(message: e.toString());
      rethrow;
    }
  }

  static launchWebRoutes(String route, {FortuneWebCommonEntity? queryParam}) async {
    final url = makeWebUrl(route: route, queryParam: queryParam);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      FortuneLogger.error(message: 'Cannot Routing :: $url');
    }
  }

  static makeWebUrl({String route = '', FortuneWebCommonEntity? queryParam}) {
    final baseUrl = getMainWebUrl();

    // 기본 URL에 route를 추가합니다.
    String fullUrl = baseUrl + '#$route';

    // queryParam이 있을 경우 인코딩하여 URL에 추가합니다.
    if (queryParam != null) {
      final content = Uri.encodeComponent(jsonEncode(queryParam.toJson()));
      fullUrl += '?data=$content';
    }

    return fullUrl;
  }

  static getMainWebUrl() => kReleaseMode ? webMainUrl : webMainDebugUrl;
}

extension WebCommandParser on String {
  WebCommand toWebCommand() {
    for (WebCommand command in WebCommand.values) {
      if (this == command.name) {
        return command;
      }
    }
    throw Exception('Unknown command: $this');
  }
}

enum WebCommand {
  close,
}
