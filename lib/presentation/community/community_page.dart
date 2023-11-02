import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/web/fortune_web_close_entity.dart';
import 'package:fortune/domain/supabase/entity/web/fortune_web_common_entity.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CommunityPage();
  }
}

class _CommunityPage extends StatefulWidget {
  const _CommunityPage();

  @override
  State<_CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<_CommunityPage> {
  late WebViewController controller;
  final _appRouter = serviceLocator<FortuneAppRouter>().router;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(fortuneWebChannel, onMessageReceived: _onMessageReceived)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(webMainUrl));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      padding: EdgeInsets.zero,
      child: WebViewWidget(controller: controller),
    );
  }

  FortuneWebCommonEntity parseWebEntity(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final WebCommand webCommand = (jsonData['command'] as String).toWebCommand();

      // 'command' 키를 기반으로 어떤 엔터티인지 판단합니다.
      switch (webCommand) {
        case WebCommand.close:
          // 예제에서는 단순히 'close' 커맨드를 사용했지만 실제로는 각 엔터티마다 명확한 커맨드를 할당해야 합니다.
          return FortuneWebCloseEntity.fromJson(jsonData);
        default:
          throw Exception('Unknown command: ${jsonData['command']}');
      }
    } catch (e) {
      FortuneLogger.error(message: e.toString());
      rethrow;
    }
  }

  _onMessageReceived(JavaScriptMessage message) {
    try {
      final entity = parseWebEntity(message.message);
      if (entity is FortuneWebCloseEntity) {
        _appRouter.pop(context);
      }
    } catch (e) {
      FortuneLogger.error(message: e.toString());
    }
  }
}
