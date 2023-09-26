import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../core/app_export.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_rich_text.dart';

class ConfirmExitScreen extends StatelessWidget {
  ConfirmExitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: profileGradientBg, //commonGradientBg,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          body: Center(child: contents(context)),
        ),
      ],
    );
  }

  Widget contents(context) {
    return Container(
      decoration: profileGradientBg,
      height: size.height,
      padding: getPadding(left: 35, right: 35, bottom: 45),
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: double.maxFinite,
                height: getVerticalSize(280),
                decoration: BoxDecoration(
                  color: Color.fromARGB(136, 0, 0, 0),
                  borderRadius: BorderRadius.circular(33.0),
                ),
                child: Padding(
                  padding: getPadding(left: 25, right: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomRichText(
                        text: TitleString.are_you_sure,
                        style: AppStyle.txtPoppinsBold17,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CustomRichText(
                        text: TitleString.exit_confirmation,
                        style: AppStyle.txtPoppinsItalic14,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomButton(
            text: TitleString.confirm,
            enabled: true,
            onTap: () async {
              // app exit here
              SystemNavigator.pop();
            },
            margin: getMargin(top: 33, bottom: 16.0),
          ),
          CustomButton(
            text: TitleString.cancel,
            variant: ButtonVariant.outlineTealA400,
            fontStyle: ButtonFontStyle.poppinsRegular15WhiteA400,
            enabled: true,
            onTap: () {
              Navigator.of(context).pop();
            },
            margin: getMargin(top: 10, bottom: 16.0),
          ),
        ],
      ),
    );
  }
}
