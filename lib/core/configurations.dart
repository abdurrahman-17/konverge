

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

import '../services/amplify/amplify_service.dart';
import '../services/comet_chat.dart';
import '../services/one_signal_service.dart';
import '../services/shared_preference_service.dart';
import 'locator.dart';

///exports
export 'providers.dart';
export 'routes.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

export '../services/one_signal_service.dart';
export '../services/deep_link_service.dart';
export '../utilities/constants.dart';
export '../utilities/theme_data.dart';

Future<void> initializeConfig() async {
  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   
  await SharedPrefServices.initializeSharedPref();
  await dotenv.load(fileName: ".dev_env");
  final sentryUrl = dotenv.env['SENTRY_URL'];
  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryUrl;
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
      },
    );
  }
  Locator.setup();
  await AmplifyService().configureAmplify();
  await oneSignalInitialize();
  await initCometChat();
  //
  return;
}

