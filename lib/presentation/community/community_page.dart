import 'package:flutter/material.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// TODO 나중에 웹 만들 때.
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CommunityPage();
  }
}

class _CommunityPage extends StatefulWidget {
  const _CommunityPage({Key? key}) : super(key: key);

  @override
  State<_CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<_CommunityPage> {
  late WebViewController controller;

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
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: FortuneTr.msgMissionHistory),
      child: WebViewWidget(controller: controller),
    );
  }
}
