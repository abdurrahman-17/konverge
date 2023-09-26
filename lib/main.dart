import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'utilities/network_listener.dart';

import 'core/configurations.dart';
import 'view/common_widgets/network_lost_screen.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Paint.enableDithering = true;
  await initializeConfig();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _connectionChangeStream;
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.instance;

//late final NotificationService notificationService;
  @override
  void initState() {
    FlutterNativeSplash.remove();

    // for network listener
    connectionStatus.initialize();

    _connectionChangeStream =
        connectionStatus.myStream.listen((dynamic hasConnection) {
      if (hasConnection) {
        //connected
        log("Main->connected");
      } else {
        log("Main->disconnected");
        Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          NetworkLostScreen.routeName,
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: globalNavigatorKey,
        title: Constants.appName,
        theme: themeData,
        themeMode: ThemeMode.light,
        onGenerateRoute: generateRoute,
        localizationsDelegates: [
          CountryLocalizations.delegate
        ],
        initialRoute: initialRoute,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _connectionChangeStream.cancel();
  }
}
