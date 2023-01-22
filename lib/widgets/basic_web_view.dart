import 'package:flutter/material.dart';
import 'package:flutter_template/feature/loading/ui/circular_progress_indicator.dart';
import 'package:flutter_template/log/log.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BasicWebView extends StatefulWidget {
  final String url;
  final VoidCallback? onBack;

  const BasicWebView({
    this.url = '',
    this.onBack,
  });

  @override
  _BasicWebViewState createState() => _BasicWebViewState();
}

class _BasicWebViewState extends State<BasicWebView> {
  final _key = UniqueKey();
  late final WebViewController _controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            Log.e(error.toString());
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          WebViewWidget(key: _key, controller: _controller),
          Visibility(
            visible: isLoading,
            child: Center(
              child: PlatformCircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
