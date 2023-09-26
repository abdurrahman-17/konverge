import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CommonAppBar {
  static PreferredSize appBar({
    String text = "",
    Widget? titleWidget,
    Widget? leading,
    List<Widget>? actions,
    required BuildContext context,
    bool visible = true,
    bool showAppBar = false,
    void Function()? onTapLeading,
    String? svgPath = Assets.imgArrowLeft,
  }) {
    return PreferredSize(
        preferredSize: Size.fromHeight(68), // Set the desired height of the app bar
    child: Padding(
    padding: getPadding(top: 18), // Set the desired padding value
    child: AppBar(

        title: titleWidget ??
            Text(
              text,
              style: AppStyle.txtPoppinsMedium14,
            ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: getHorizontalSize(70),

        leading: Visibility(
          visible: visible,
          child: leading ??
              Container(
                margin: getMarginOrPadding(left: 20),
                child: ModalRoute.of(context)!.canPop || showAppBar
                    ? IconButton(
                  hoverColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  focusColor: AppColors.transparent,
                  splashColor: AppColors.transparent,
                  icon: CustomLogo(
                    svgPath: svgPath,
                    width: getHorizontalSize(19),
                    fit: BoxFit.fitWidth,
                    color: AppColors.whiteA700,
                  ),
                  onPressed: onTapLeading ?? () {
                    Navigator.pop(context);
                  },
                )
                    : null,
              ),
        ),
        actions: actions ?? [],
        iconTheme: IconThemeData(color: AppColors.whiteFFF),
      ),
    ));
  }
}
