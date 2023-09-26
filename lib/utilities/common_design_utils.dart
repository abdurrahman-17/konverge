// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../models/app_update_model.dart';
import '../models/design_models/match_data.dart';
import '../theme/app_style.dart';
import 'colors.dart';

String capitalizeWords(String input) {
  final words = input.split(' ');
  final capitalizedWords = words.map((word) {
    final firstLetter = word.substring(0, 1).toUpperCase();
    final remainingLetters = word.substring(1).toLowerCase();
    return '$firstLetter$remainingLetters';
  });

  return capitalizedWords.join(' ');
}

Future<void> launchForceUpdate(AppUpdateModel data) async {
  if (data.isForceUpdate! || data.isNormalUpdate!) {
    final url = Platform.isAndroid ? data.androidUrl : data.iosUrl;
    final latestVersion =
        Platform.isAndroid ? data.androidVersion : data.iosVersion;
    final packageInfo = await PackageInfo.fromPlatform();
    try {
      final appVersion = int.parse(packageInfo.buildNumber);

      if (latestVersion! > appVersion) {
        showUpdatePopup(
          globalNavigatorKey.currentContext!,
          url: url!,
          isForceUpdate: data.isForceUpdate!,
          package: packageInfo,
        );
      }
    } catch (_) {
      print("exception_forceUpdate");
      print(_.toString());
    }
  }
}

Future<void> showUpdatePopup(
  BuildContext context, {
  required String url,
  required bool isForceUpdate,
  required PackageInfo package,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Update App?",
            style: AppStyle.txtPoppinsBold17,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "A new version of ${package.appName} is available on the ${Platform.isAndroid ? "Play store" : "App Store"}",
                  textAlign: TextAlign.center,
                  style: AppStyle.txtRobotoRegular16,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Would you like to update?",
                  textAlign: TextAlign.center,
                  style: AppStyle.txtPoppinsRegular13W400WhiteA700,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isForceUpdate)
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: Color.fromRGBO(33, 150, 243, 1),
                            ),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        child: Text(
                          "LATER",
                          maxLines: 1,
                          style: AppStyle.txtPoppinsSemiBold14,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pop(context);
                        launchURL(url);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff00A33C)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      child: Text(
                        "UPDATE NOW",
                        maxLines: 1,
                        style: AppStyle.txtPoppinsSemiBold14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      );
    },
  );
}

Future<void> launchURL(String url) async {
  var uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    throw 'Could not launch $uri: $e';
  }
}

Map<String, Color> colorCodes = {
  "INTJ": AppColors.forestGreen,
  "INTP": AppColors.mintGreen,
  "ENTJ": AppColors.emeraldGreen,
  "ENTP": AppColors.limeGreen,
  "INFJ": AppColors.violet,
  "INFP": AppColors.purple,
  "ENFJ": AppColors.flamingoPink,
  "ENFP": AppColors.hotPink,
  "ISTJ": AppColors.navyBlue,
  "ISFJ": AppColors.royalBlue,
  "ESTJ": AppColors.skyBlue,
  "ESFJ": AppColors.turquoise,
  "ISTP": AppColors.yellow,
  "ISFP": AppColors.amber,
  "ESTP": AppColors.orange,
  "ESFP": AppColors.red,
};

MatchData getColorCodeFromPersonalityCode(
  String personalityCode,
  double radius,
) {
  MatchData matchDataColorCode = MatchData(
    radius: radius,
    gradCircle1: [
      colorCodes[personalityCode] ?? AppColors.whiteA700,
      colorCodes[personalityCode] ?? AppColors.whiteA700
    ],
    gradCircle2: [
      colorCodes[personalityCode] ?? AppColors.whiteA700,
      colorCodes[personalityCode] ?? AppColors.whiteA700,
      colorCodes[personalityCode] ?? AppColors.whiteA700
    ],
    color1: colorCodes[personalityCode] ?? AppColors.whiteA700,
    color2: colorCodes[personalityCode] ?? AppColors.whiteA700,
  );
  return matchDataColorCode;
}

MatchData getColorCodeFromColors(
  Color? personalityCode,
  double radius,
) {
  MatchData matchDataColorCode = MatchData(
    radius: radius,
    gradCircle1: [
      personalityCode ?? AppColors.whiteA700,
      personalityCode ?? AppColors.whiteA700
    ],
    gradCircle2: [
      personalityCode ?? AppColors.whiteA700,
      personalityCode ?? AppColors.whiteA700,
      personalityCode ?? AppColors.whiteA700
    ],
    color1: personalityCode ?? AppColors.whiteA700,
    color2: personalityCode ?? AppColors.whiteA700,
  );
  return matchDataColorCode;
}
