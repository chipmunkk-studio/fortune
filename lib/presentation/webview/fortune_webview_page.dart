import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command_new_page.dart';
import 'package:fortune/presentation-web/fortune_web_ext.dart';
import 'package:fortune/presentation/webview/bloc/fortune_webview.dart';
import 'package:fortune/presentation/webview/fortune_webview_args.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FortuneWebViewPage extends StatelessWidget {
  final FortuneWebViewArgs args;

  const FortuneWebViewPage(
    this.args, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<FortuneWebviewBloc>()..add(FortuneWebviewInit(args)),
      child: _FortuneWebViewPage(args),
    );
  }
}

class _FortuneWebViewPage extends StatefulWidget {
  final FortuneWebViewArgs args;

  const _FortuneWebViewPage(this.args);

  @override
  State<_FortuneWebViewPage> createState() => _FortuneWebViewPageState();
}

class _FortuneWebViewPageState extends State<_FortuneWebViewPage> {
  late WebViewController controller;
  final _appRouter = serviceLocator<FortuneAppRouter>().router;
  late final FortuneWebviewBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FortuneWebviewBloc>(context);
    controller = _initializeWebViewController();
    controller.loadRequest(Uri.parse(widget.args.url));
  }

  WebViewController _initializeWebViewController() {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: _handleNavigationRequest,
        ),
      );
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    if (request.url.startsWith(FortuneWebExtension.baseUrl)) {
      final response = FortuneWebExtension.parseAndGetUrlWithQueryParam(request.url);
      switch (response.data?.command) {
        case WebCommand.close:
          _appRouter.pop(context);
          return NavigationDecision.prevent;
        case WebCommand.newWebPage:
          final commandEntity = response.data as FortuneWebCommandNewPage;
          _appRouter.navigateTo(
            context,
            AppRoutes.fortuneWebViewRoutes,
            routeSettings: RouteSettings(
              arguments: FortuneWebViewArgs(
                url: commandEntity.url,
              ),
            ),
          );
          return NavigationDecision.prevent;
        default:
          return NavigationDecision.navigate;
      }
    }
    return NavigationDecision.navigate;
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      padding: EdgeInsets.zero,
      child: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
