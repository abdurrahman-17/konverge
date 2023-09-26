import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

import '../../../utilities/styles/common_styles.dart';
import '../../utilities/network_listener.dart';
import 'custom_rich_text.dart';

class NetworkLostScreen extends StatefulWidget {
  static const String routeName = 'network_lost_screen';

  const NetworkLostScreen({
    super.key,
    this.isSplash = false,
  });

  final bool isSplash;

  @override
  State<NetworkLostScreen> createState() => _NetworkLostScreenState();
}


class _NetworkLostScreenState extends State<NetworkLostScreen> {
  late StreamSubscription _connectionChangeStream;
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.instance;

  @override
  void initState() {
    super.initState();
    _connectionChangeStream =
        connectionStatus.myStream.listen((dynamic hasConnection) {
      if (hasConnection) {
        //connected
        log("NetworkLostScreen->connected");
        // Navigator.pop(context, widget.isSplash);
        Navigator.pop(context, true);
      } else {
        log("NetworkLostScreen->disconnected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Stack(
        children: [
          commonBackground,
          Container(
            //decoration: commonGradientBg,
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: contents(context),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget contents(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: getPadding(left: 35, right: 35),
      child: Center(
        child: Container(
          height: getVerticalSize(300),
          decoration: AppDecoration.outlineBlack900351.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder35,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: getHorizontalSize(25),
            vertical: getVerticalSize(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              CustomLogo(
                svgPath: Assets.imgSignal,
                height: getHorizontalSize(64),
                width: getHorizontalSize(64),
              ),
              SizedBox(height: 35),
              CustomRichText(
                text: "Looks like you've lost connection",
                style: AppStyle.txtPoppinsMedium20,
                textAlign: TextAlign.center,
              ),
              Spacer(),
              CustomRichText(
                text: "Please reconnect to use the app",
                style: AppStyle.txtPoppinsRegular14.copyWith(
                  color: AppColors.whiteACACAC,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return false;
  }

  @override
  void dispose() {
    // connectionStatus.disposeStream();
    _connectionChangeStream.cancel();
    super.dispose();
  }
}
