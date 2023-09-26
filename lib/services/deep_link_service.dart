// // ignore_for_file: avoid_catches_without_on_clauses, avoid_print, unused_local_variable

// import 'dart:async';
// import 'dart:developer';

// import 'package:app_links/app_links.dart';

// ///firebase dynamic link handling
// Future<void> deepLinkHandling() async {
//   //navigation
//   navigation(String oobCode) {
//     try {
//       // Future.delayed(const Duration(seconds: 1), () {
//       //   Navigator.pushAndRemoveUntil(
//       //       globalNavigatorKey.currentContext!,
//       //       MaterialPageRoute(
//       //           builder: (ctx) => ResetPasswordScreenWidget(oobCode)),
//       //       (route) => false);
//       // });
//     } catch (e) {
//       print("navigation_exception:$e");
//     }
//   }

//   late AppLinks appLinks;
//   StreamSubscription<Uri>? linkSubscription;
//   appLinks = AppLinks();
//   final appLink = await appLinks.getInitialAppLink();
//   if (appLink != null) {
//     var params = appLink.queryParameters;
//     var oobCode = getCode(params);
//     navigation(oobCode);
//   }
//   // Handle link when app is in warm state (front or background)
//   linkSubscription = appLinks.uriLinkStream.listen((uri) {
//     log('onAppLink: $uri');
//     var params = uri.queryParameters;
//     var oobCode = getCode(params);
//     navigation(oobCode);
//   });
// }

// ///extracting reset code from link based on the OS
// String getCode(Map<String, String> queryParams) {
//   try {
//     if (queryParams.containsKey('code')) {
//       return queryParams['code']!;
//     } else {
//       String link = queryParams['link']!;
//       var oobCode = link.split("=")[1];
//       return oobCode;
//     }
//   } catch (e) {
//     log("$e");
//     return '';
//   }
// }
