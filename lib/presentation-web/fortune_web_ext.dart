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
  static const webMainUrl = "https://chipmunk-studio.com/#";
  static const webMainDebugUrl = "https://fortune-50ef2--develop-7ospx4vb.web.app/#";

  static FortuneWebResponse parseAndGetUrlWithQueryParam(String url) {
    try {
      final uri = Uri.parse(url);
      final dataStr = uri.queryParameters['data'];
      final routes = uri.fragment;
      FortuneWebCommonEntity? param;

      if (dataStr != null) {
        final jsonMap = jsonDecode(dataStr);
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
    const url = kReleaseMode ? webMainUrl : webMainDebugUrl;
    final uri = Uri.parse(url + route);
    if (queryParam != null) {
      return uri.replace(queryParameters: {
        'data': queryParam.toJson(),
      });
    }
    return uri.toString();
  }

  static getMainWebUrl() => kReleaseMode ? webMainUrl : webMainDebugUrl;
}
