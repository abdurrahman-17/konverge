import 'package:flutter/material.dart';

import '../../../models/ideas/ideas.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/size_utils.dart';
import '../../common_widgets/custom_logo.dart';
import '../../common_widgets/custom_textfield.dart';

class IdeaItem extends StatefulWidget {
  final bool isSelected;
  final Ideas idea;
  final AnimationController? animationController;

  IdeaItem({
    super.key,
    required this.idea,
    this.isSelected = true,
    this.animationController,
  });

  @override
  State<IdeaItem> createState() => _IdeaItemState();
}

class _IdeaItemState extends State<IdeaItem> with TickerProviderStateMixin {
  Animation<double>? animation;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    animation = Tween<double>(begin: -20, end: 0.0)
        .animate(widget.animationController!)
      ..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: getPadding(top: 18),
          child: Row(
            children: [
              widget.isSelected
                  ? Container(
                      height: getSize(20),
                      width: getSize(20),
                      padding: getPadding(all: 0),
                      child: Center(
                        child: CustomLogo(
                          svgPath: Assets.imgVectorWhiteA700,
                          fit: BoxFit.contain,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tealA700,
                        borderRadius:
                            BorderRadius.circular(getHorizontalSize(10)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: AppColors.black9003f,
                        //     spreadRadius: getHorizontalSize(2),
                        //     blurRadius: getHorizontalSize(2),
                        //     offset: const Offset(0, 1),
                        //   ),
                        // ],
                      ),
                    )
                  // CustomIconButton(
                  //         height: getSize(20),
                  //         width: getSize(20),
                  //         padding: IconButtonPadding.paddingAll0,
                  //         child: CustomLogo(
                  //           svgPath: Assets.imgVectorWhiteA700,
                  //         ),
                  //       )
                  : Container(
                      height: getSize(20),
                      width: getSize(20),
                      // margin: getPadding(all: 0),
                      decoration: BoxDecoration(
                        color: AppColors.blueGray10033,
                        borderRadius:
                            BorderRadius.circular(getHorizontalSize(10)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black9003f,
                            spreadRadius: getHorizontalSize(2),
                            blurRadius: getHorizontalSize(2),
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
              Padding(
                padding: getPadding(left: 13),
                child: Text(
                  widget.idea.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsMedium14,
                ),
              ),
            ],
          ),
        ),
        if (widget.isSelected && widget.idea.controller != null)
          AnimatedBuilder(
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, animation!.value),
                child: Form(
                  key: widget.idea.globalKey,
                  child: CustomTextFormField(
                    isNotDispose: true,
                    autoValidateMode: AutovalidateMode.disabled,
                    focusNode: focusNode,
                    controller: widget.idea.controller,
                    hintText: "Describe your idea in a couple of sentences",
                    margin: getMargin(top: 20),
                    maxLength: 180,
                    onChanged: (val) {
                      if (val.length < 50) {
                        setState(() {
                        });
                      }
                      if (val.length >= 50) {
                        setState(() {
                          widget.idea.globalKey!.currentState!.validate();
                        });
                      }
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "";
                      }
                      if (val.length < 50) {
                        return "Minimum character limit : 50";
                      }
                      return null;
                    },
                    padding: TextFormFieldPadding.paddingV12H15,
                    variant: TextFormFieldVariant.outlineBlack90035,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                    textInputAction: TextInputAction.done,
                    maxLines: 4,
                    focusedInputBorder: widget.idea.controller!.text.length < 50 ? TextFormFieldVariant.outlineBlack90035 : TextFormFieldVariant.outlineTealA400,
                  ),
                ),
              );
            },
            animation: animation!,
          ),
      ],
    );
  }
}
