import 'package:flutter/material.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/navigation/fortune_web_router.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation-web/fortune_web_ext.dart';
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
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(FortuneWebExtension.getMainWebUrl())) {
              final response = FortuneWebExtension.parseAndGetUrlWithQueryParam(request.url);
              if (response.routes == WebRoutes.exitRoute) {
                _appRouter.pop(context);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(FortuneWebExtension.getMainWebUrl()));
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
}
