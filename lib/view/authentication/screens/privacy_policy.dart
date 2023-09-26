import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/loader.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  static const String routeName = 'privacy_policy';


  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}


class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final String url = 'https://konverge.club/privacy-policy';
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
  }
  bool isLoading = true;
  bool isLoadingFinished = false;
  @override
  Widget build(BuildContext context) {
    // return Stack(
    //   children: [
    //     Container(
    //       decoration: commonGradientBg,
    //       width: double.infinity,
    //       height: double.infinity,
    //     ),
    //     // CommonBgLogo(
    //     //   opacity: 0.6,
    //     // ),
    //     Scaffold(
    //       resizeToAvoidBottomInset: true,
    //       body: WebView(
    //         initialUrl: url,
    //         javascriptMode: JavascriptMode.unrestricted,
    //       ),
    //       appBar: CommonAppBar.appBar(context: context),
    //       backgroundColor: Colors.transparent,
    //     ),
    //   ],
    // );
    return Stack(
      children: [
       commonBackground,
        // CommonBgLogo(
        //   opacity: 0.6,
        // ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Visibility(
                child: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onProgress: (int progress) {},
                  onPageStarted: (_) {
                  },
                  onPageFinished: (_) {
                    setState(() {
                      isLoading = false;
                      isLoadingFinished=true;
                    });
                  },
                ),
                maintainState:true,
                visible:isLoadingFinished ,
              ),
              if (isLoading)
                Stack(
                  children: [
                    commonBackground,
                    Center(
                      child: Loader(),
                    ),
                  ],
                ),
            ],
          ),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
