import 'package:flutter/material.dart';
import 'package:flutter_template/feature/loading/ui/circular_progress_indicator.dart';
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
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          WebView(
            backgroundColor: Colors.transparent,
            key: _key,
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: onPageFinished,
          ),
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

  void onPageFinished(String url) {
    setState(() {
      isLoading = false;
    });
  }
}
