import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zenshield/core/widgets/black_circular_progress_indicator.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';

class WebView extends StatefulWidget {
  const WebView({
    required this.url,
    super.key,
  });

  final Uri url;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  WebViewController? controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (controller == null) {
      final appColors = AppColors();

      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(appColors.background)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return controller != null
        ? Stack(
            alignment: Alignment.center,
            children: [
              const BlackCircularProgressIndicator(),
              Container(
                padding: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: WebViewWidget(controller: controller!),
              ),
            ],
          )
        : Container();
  }
}