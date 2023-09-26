import 'package:flutter/material.dart';
import '../../../utilities/transition_constant.dart';

import '../../../models/skills/skills.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/transition/shake_widget.dart';
import '../../common_widgets/custom_logo.dart';
import '../../common_widgets/custom_rich_text.dart';

class SkillItem extends StatefulWidget {
  final Skills skill;
  final bool isSelected;
  final bool isLast;
  final int? index;
  final int? length;
  final int? maxSelectLimit;

  SkillItem({
    super.key,
    required this.skill,
    this.isSelected = false,
    this.isLast = false,
    this.index,
    this.length,
    this.maxSelectLimit,
  });

  @override
  State<SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<SkillItem> {
  bool startAnimation = false;
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.length == widget.maxSelectLimit && !widget.isSelected
          ? () {
              shakeKey.currentState!.shake();
            }
          : null,
      child: ShakeWidget(
        key: shakeKey,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: Duration(
          milliseconds: TransitionConstant.skillItemShakeTransitionDuration,
        ),
        child: AnimatedContainer(
          width: double.infinity,
          duration: Duration(
            milliseconds: widget.index == null
                ? 0
                : TransitionConstant.skillItemTransitionDuration +
                    (widget.index! * 20),
          ),
          curve: Curves.easeIn,
          transform: Matrix4.translationValues(
            widget.index == null
                ? 0
                : startAnimation
                    ? 0
                    : MediaQuery.of(context).size.width,
            0,
            0,
          ),
          child: Column(
            children: [
              Divider(
                height: 2,
                color: AppColors.gray500,
              ),
              Container(
                margin: getMargin(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomRichText(
                      text: widget.skill.skill,
                      style: widget.isSelected
                          ? AppStyle.txtPoppinsRegular14Teal
                          : AppStyle.txtPoppinsRegular14WhiteA700,
                    ),
                    if (widget.isSelected)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              getPadding(left: 7, top: 8, right: 7, bottom: 8),
                          //margin: getMargin(left: 30),
                          decoration: BoxDecoration(
                            color: AppColors.tealA700,
                            borderRadius:
                                BorderRadius.circular(getHorizontalSize(10)),
                          ),
                          child: CustomLogo(
                            svgPath: Assets.imgVectorWhiteA700,
                          ),
                        ),
                      )
                  ],
                ),
              ),
              if (widget.isLast)
                Divider(
                  height: 2,
                  color: AppColors.gray500,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
