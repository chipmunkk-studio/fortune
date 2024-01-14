import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/widgets/fortune_loading_view.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command_new_page.dart';
import 'package:fortune/presentation-web/fortune_web_ext.dart';
import 'package:fortune/presentation/webview/bloc/fortune_webview.dart';
import 'package:fortune/presentation/webview/fortune_webview_args.dart';

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
  late InAppWebViewController controller;

  final _appRouter = serviceLocator<FortuneAppRouter>().router;

  late final FortuneWebviewBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FortuneWebviewBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // 프로그레스 바
            BlocBuilder<FortuneWebviewBloc, FortuneWebviewState>(
              buildWhen: (previous, current) => previous.loadingProgress != current.loadingProgress,
              builder: (context, state) {
                final progress = state.loadingProgress;
                return LinearProgressIndicator(
                  value: progress,
                  backgroundColor: ColorName.grey900,
                  valueColor: AlwaysStoppedAnimation<Color>(progress != 100 ? ColorName.primary : Colors.transparent),
                );
              },
            ),
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.args.url)),
              onWebViewCreated: (InAppWebViewController webViewController) {
                controller = webViewController;
              },
              onProgressChanged: (controller, progress) {
                _bloc.add(FortuneWebviewLoading(progress));
              },
              onLoadStop: (controller, _) {
                _bloc.add(FortuneWebviewLoadingComplete());
              },
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  javaScriptEnabled: true,
                  transparentBackground: true,
                ),
              ),
              shouldOverrideUrlLoading: (controller, request) async {
                return _handleNavigationRequest(request);
              },
            ),
            BlocBuilder<FortuneWebviewBloc, FortuneWebviewState>(
              buildWhen: (previous, current) => previous.isLoading != current.isLoading,
              builder: (context, state) {
                return state.isLoading ? const Center(child: FortuneLoadingView()) : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  NavigationActionPolicy _handleNavigationRequest(NavigationAction action) {
    final url = action.request.url!.toString();
    if (url.startsWith(FortuneWebExtension.baseUrl)) {
      final response = FortuneWebExtension.parseAndGetUrlWithQueryParam(url);
      switch (response.data?.command) {
        case WebCommand.close:
          _appRouter.pop(context);
          return NavigationActionPolicy.CANCEL;
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
          return NavigationActionPolicy.CANCEL;
        default:
          return NavigationActionPolicy.ALLOW;
      }
    }
    return NavigationActionPolicy.ALLOW;
  }
}
