import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utilities/styles/common_styles.dart';
import '../common_widgets/common_app_bar.dart';
import '../common_widgets/loader.dart';

class TermsAndConditionScreen extends StatefulWidget {
  static const String routeName = 'terms_condition';

  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

bool isLoading = false;

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  final String url = 'https://konverge.club/terms-of-service';

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
       commonBackground,
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: WebView(
            gestureNavigationEnabled: true,
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {},
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              setState(() {
                visible = true;
              });
            },
          ),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
        if (!visible) Stack(
          children: [
            commonBackground,
            const Loader(),
          ],
        ),
      ],
    );
  }
}
