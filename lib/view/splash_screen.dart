// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:konverge/models/app_update_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../blocs/graphql/graphql_bloc.dart';
import '../../blocs/graphql/graphql_event.dart';
import '../../blocs/graphql/graphql_state.dart';
import '../../core/configurations.dart';
import '../../utilities/common_navigation_logics.dart';
import '../blocs/remote_config/remote_config_bloc.dart';
import '../core/app_export.dart';
import '../core/locator.dart';
import '../main.dart';
import '../services/amplify/amplify_service.dart';

import '../utilities/network_listener.dart';
import '../utilities/common_design_utils.dart';
import '../utilities/enums.dart';
import 'authentication/screens/get_started_screen.dart';
import 'authentication/screens/sign_up_screen.dart';
import 'common_widgets/common_dialogs.dart';
import 'common_widgets/network_lost_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "/";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;
  String tag = "SplashScreen: ";

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => startTimer());
    log("$tag initState Time: ${DateTime.now().millisecondsSinceEpoch}");
    BlocProvider.of<RemoteConfigBloc>(context)
        .add(RemoteConfigLoginTypesEvent());
  }

  Future<void> startTimer() async {
    log("$tag initial data reading starting: ${DateTime.now().millisecondsSinceEpoch}");
    ConnectionStatusSingleton connectivity = ConnectionStatusSingleton.instance;
    bool isConnected = await connectivity.checkConnectionStatus();
    if (!isConnected) {
      final data = await Navigator.pushNamed(
        globalNavigatorKey.currentContext!,
        NetworkLostScreen.routeName,
        arguments: {
          "isSplash": true,
        },
      );
      if (data != null && data as bool) {
        log("$tag reading logged in user status: ${DateTime.now().millisecondsSinceEpoch}");
        bool isUserLoggedIn =
            await Locator.instance.get<AmplifyService>().isUserLoggedIn();
        log("isUserLoggedIn:$isUserLoggedIn");
        log("$tag logged in user status read done: ${DateTime.now().millisecondsSinceEpoch}");

        if (!isUserLoggedIn) {
          Navigator.pushReplacementNamed(
            context,
            GetStartedScreen.routeName,
          );
        } else {
          log("$tag reading logged in user details from graphql: ${DateTime.now().millisecondsSinceEpoch}");
          BlocProvider.of<GraphqlBloc>(context).add(
            const ReadLoggedInUserInfoEvent(),
          );
        }
      }
      return;
    } else {
      bool isUserLoggedIn =
          await Locator.instance.get<AmplifyService>().isUserLoggedIn();
      log("isUserLoggedIn:$isUserLoggedIn");
      if (!isUserLoggedIn) {
        Navigator.pushReplacementNamed(
          context,
          GetStartedScreen.routeName,
        );
      } else {
        try {
          log("$tag reading logged in user details from graphql: ${DateTime.now().millisecondsSinceEpoch}");
          BlocProvider.of<GraphqlBloc>(context).add(
            const ReadLoggedInUserInfoEvent(),
          );
        } catch (e) {
          print("Could not read logged in user data . " + e.toString());
        }
      }
    }
  }

  Future<void> checkJailBrake() async {
    bool jailbreakMode;
    bool developerMode;
    try {
      jailbreakMode = await FlutterJailbreakDetection.jailbroken;
      developerMode = Platform.isAndroid
          ? await FlutterJailbreakDetection.developerMode
          : false;
    } on PlatformException {
      jailbreakMode = true;
      developerMode = true;
    }

    if (jailbreakMode || developerMode) {
      showInfo(
        globalNavigatorKey.currentContext!,
        title: "Alert",
        content: "The following critical threats have been found on your "
            "mobile device.For your security, this application will now quit"
            "?\nRoot / Jail broken",
        buttonLabel: "Quit",
        onTap: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoteConfigBloc, RemoteConfigState>(
      listener: (context, state) {
        if (state is RemoteConfigLoginTypeState) {
          if (state.status == ProviderStatus.loaded) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) async {
                final configModel = state.remoteConfigModel;
                if (configModel != null) {
                  AppUpdateModel updateModel = configModel.updateModel;
                  final latestVersion = Platform.isAndroid
                      ? updateModel.androidVersion
                      : updateModel.iosVersion;
                  final packageInfo = await PackageInfo.fromPlatform();
                  bool status = true;
                  try {
                    final appVersion = int.parse(packageInfo.buildNumber);
                    if (latestVersion! > appVersion &&
                        updateModel.isForceUpdate == true) {
                      status = false;
                    }
                  } catch (_) {
                    print("exception_forceUpdate");
                    print(_.toString());
                  }
                  log("$tag ForceUpdate Read from remote config done: ${DateTime.now().millisecondsSinceEpoch}");
                  launchForceUpdate(updateModel);
                  if (status) startTimer();
                }
              },
            );
          } else if (state.status == ProviderStatus.error) {
            startTimer();
          }
        }
      },
      child: BlocListener<GraphqlBloc, GraphqlState>(
        listener: (BuildContext context, state) {
          isLoading = false;
          switch (state.runtimeType) {
            case ReadUserSuccessState:
              /*  Navigator.pushNamedAndRemoveUntil(
                context,
                ResultScreen.routeName,
                    (Route<dynamic> route) => false,
              );*/
              log("$tag success reading logged in user details from graphql: ${DateTime.now().millisecondsSinceEpoch}");
              readStageOfLoggedInUserAndNavigate(context);
              break;
            case QueryLoadingState:
              isLoading = false;
              break;
            case GraphqlErrorState:
              log("GraphqlErrorState: $state ${(state as GraphqlErrorState).errorMessage}");
              log("no user data on db");
              Navigator.pushNamedAndRemoveUntil(
                context,
                SignUpScreen.routeName,
                (Route<dynamic> route) => false,
              );
              break;
            default:
              log("Unknown state while logging in: $state");
          }
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child:
                  SvgPicture.asset(Assets.backgroundImage, fit: BoxFit.cover),
            ),
            Scaffold(
              resizeToAvoidBottomInset: true,
              body: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomLogo(
                      svgPath: Assets.imgVector,
                      height: getVerticalSize(103),
                      width: getHorizontalSize(107),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget contents() {
    return SizedBox(
      height: size.height,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            child: Container(
              height: size.height,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.black9004c,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<GraphqlBloc>(context).add(
                const ReadLoggedInUserInfoEvent(),
              );
            },
            child: CustomLogo(
              svgPath: Assets.imgVector,
              height: getVerticalSize(103),
              width: getHorizontalSize(107),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
