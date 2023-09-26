import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utilities/transition_constant.dart';

import '../../main.dart';
import '../../theme/app_decoration.dart';
import '../../utilities/colors.dart';
import '../../utilities/size_utils.dart';
import 'custom_buttons.dart';

Future<bool> confirmationPopup({
  required String title,
  required String message,
  String? cancelBtnLabel,
  String? successBtnLabel,
}) async {
  bool? confirmed = await showGeneralDialog(
    context: globalNavigatorKey.currentContext!,
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: const Duration(
        milliseconds: TransitionConstant.confirmPopUpTransitionDuration),
    pageBuilder: (_, __, ___) {
      return Container(
        decoration: AppDecoration.outlineBlack900351.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder35,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.black9004c,
              AppColors.indigo90001,
              AppColors.cyan900,
              AppColors.cyan90001,
            ],
          ),
        ),
        child: AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                getHorizontalSize(25),
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomElevatedButton(
                      textStyle: const TextStyle(color: Colors.white),
                      width: getHorizontalSize(130),
                      height: getVerticalSize(40),
                      onTap: () {
                        Navigator.pop(
                            globalNavigatorKey.currentContext!, false);
                      },
                      title: cancelBtnLabel ?? 'CANCEL',
                    ),
                    SizedBox(
                      width: getHorizontalSize(5),
                    ),
                    CustomElevatedButton(
                      width: getHorizontalSize(130),
                      height: getVerticalSize(40),
                      buttonBgColor: Color(0xff34F4A4),
                      onTap: () async {
                        Navigator.pop(globalNavigatorKey.currentContext!, true);
                      },
                      title: successBtnLabel ?? 'CONFIRM',
                    ),
                  ],
                ),
                SizedBox(
                  height: getVerticalSize(20),
                )
              ],
            ),
          ],
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }
      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
  return confirmed ?? false;
}

///popup with content and button only
Future<void> showInfo(
  BuildContext context, {
  required String content,
  required String buttonLabel,
  String? title,
  VoidCallback? onTap,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              getHorizontalSize(9),
            ),
          ),
          title: title != null
              ? Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                )
              : null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.whiteA700, // Set the text color to white
                  ),
                ),
              ),
              SizedBox(
                height: getHorizontalSize(25),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: getHorizontalSize(40),
                      child: ElevatedButton(
                        onPressed: onTap ??
                            () {
                              Navigator.pop(context);
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tealA400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(27.5),
                            ),
                          ),
                        ),
                        child: Text(
                          buttonLabel,
                          style: TextStyle(
                            color: AppColors
                                .black900, // Set the text color to white
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<ImageSource?> showSelectPhotoOptions(BuildContext context) async {
  ImageSource? imageOption = await showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    barrierColor: Colors.black12,
    context: context,
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () async => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Photos'),
              onTap: () async => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );
  return imageOption;
}
