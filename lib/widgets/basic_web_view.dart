import 'package:flutter_template/feature/loading/ui/circular_progress_indicator.dart';
import 'package:flutter_template/resources/styles/text_styles.dart';
import 'package:flutter_template/widgets/modal_sheet_presentation.dart';
import 'package:flutter_template/widgets/transparent_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef void OnBackCallback();

Future<void> showWebView(
    BuildContext context, {
      String title = '',
      String content = '',
      bool dragEnabled = true,
      OnBackCallback? onBack,
    }) async {
  return showModalSheet(
    context,
    content: BasicWebView(
      title: title,
      url: content,
      onBack: onBack,
    ),
    dragEnabled: dragEnabled,
  );
}

class BasicWebView extends StatefulWidget {
  final String title;
  final String url;
  final OnBackCallback? onBack;

  const BasicWebView({
    this.title = '',
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
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = [
      Factory(() => EagerGestureRecognizer()),
    ].toSet();

    return SafeArea(
      child: Scaffold(
        appBar: TransparentAppBar(
          title: Text(
            widget.title,
            style: kAppBarTextStyle,
          ),
          leading: BackButton(
            onPressed: () => widget.onBack != null
                ? widget.onBack!.call()
                : Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              key: _key,
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: onPageFinished,
              gestureRecognizers: gestureRecognizers,
            ),
            Visibility(
              visible: isLoading,
              child: Center(
                child: PlatformCircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPageFinished(String url) {
    setState(() {
      isLoading = false;
    });
  }
}
