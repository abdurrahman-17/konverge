import 'dart:developer';

import 'package:flutter/material.dart';
import '../../utilities/transition_constant.dart';
import '../../models/questionnaire/questionnaire.dart';

import '../../theme/app_style.dart';
import '../../utilities/colors.dart';
import '../../utilities/size_utils.dart';

class SlidableWidget extends StatefulWidget {
  const SlidableWidget({
    super.key,
    required this.question,
    required this.onChange,
  });

  final Questionnaire question;
  final Function onChange;

  @override
  State<SlidableWidget> createState() => _SlidableWidgetState();
}

class _SlidableWidgetState extends State<SlidableWidget>
    with TickerProviderStateMixin {
  // final double _value = 40.0;

//Horizontal drag details
  DragStartDetails? startHorizontalDragDetails;
  DragUpdateDetails? updateHorizontalDragDetails;
  double center = size.width / 2;
  double currentPos = size.width / 2;
  double width = getHorizontalSize(305);
  double fact = getHorizontalSize(147) / getHorizontalSize(305);
  double height = getHorizontalSize(147);
  AnimationController? _controller2;
  String previousText = "";

  @override
  void initState() {
    setValue();
    _controller2 = AnimationController(
        duration: const Duration(
            milliseconds: TransitionConstant.slidablePageTransitionDuration),
        vsync: this,
        value: 1.0);
    _controller2!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller2!.dispose();
    super.dispose();
  }

  void setValue() {
    height = (147 / 305) * width;
    fact = height / width;
    int percentage = widget.question.percentage;
    if (percentage == -1) {
      percentage = 50;
    }
    if (percentage < 50) {
      double value = (50 - percentage) / 100;
      double width = (value * getHorizontalSize(305));
      currentPos = center - width;
    } else if (percentage > 50) {
      double value = (percentage - 50) / 100;
      double width = value * getHorizontalSize(305);
      currentPos = width + center;
    } else {
      currentPos = center;
    }
  }

  @override
  Widget build(BuildContext context) {
    setValue();
    // ignore: non_constant_identifier_names
    Widget CustomSliderGestureWidget({required Widget child}) {
      return GestureDetector(
        onHorizontalDragStart: (dragDetails) {
          startHorizontalDragDetails = dragDetails;
          if (startHorizontalDragDetails != null) {
            setState(() {
              currentPos = startHorizontalDragDetails!.globalPosition.dx;
              double value = 0;
              double percentage = 0;
              value = getWidth() / getHorizontalSize(305);
              if (center > currentPos) {
                percentage = 50 - (value * 100);
                widget.question.code = widget.question.agree != null
                    ? widget.question.agree?.code.toString() ?? ''
                    : "D";
              } else {
                percentage = 50 + (value * 100);
                widget.question.code = widget.question.disagree != null
                    ? widget.question.disagree?.code.toString() ?? ''
                    : "A";
              }

              widget.question.percentage = percentage.toInt();
              if (widget.question.percentage == 50) {
                widget.question.code = widget.question.agree != null
                    ? widget.question.agree?.code.toString() ?? ''
                    : "A";
              }
            });
          }
          widget.onChange();
        },
        onHorizontalDragUpdate: (dragDetails) {
          updateHorizontalDragDetails = dragDetails;
          if (updateHorizontalDragDetails != null) {
            setState(() {
              currentPos = updateHorizontalDragDetails!.globalPosition.dx;

              double value = 0;
              double percentage = 0;
              value = getWidth() / getHorizontalSize(305);
              if (center > currentPos) {
                percentage = 50 - (value * 100);
                widget.question.code = widget.question.agree != null
                    ? widget.question.agree?.code.toString() ?? ''
                    : "D";
              } else {
                percentage = 50 + (value * 100);
                widget.question.code = widget.question.disagree != null
                    ? widget.question.disagree?.code.toString() ?? ''
                    : "A";
              }

              widget.question.percentage = percentage.toInt();
              if (widget.question.percentage == 50) {
                widget.question.code = widget.question.agree != null
                    ? widget.question.agree?.code.toString() ?? ''
                    : "A";
              }
            });
          }
          widget.onChange();
        },
        onHorizontalDragEnd: (dragEndDetails) {
          if (startHorizontalDragDetails != null &&
              updateHorizontalDragDetails != null) {
            // double dx = updateHorizontalDragDetails!.globalPosition.dx -
            //     startHorizontalDragDetails!.globalPosition.dx;
            if ((dragEndDetails.primaryVelocity ?? 0) > 0) {
              // Page forwards
            } else if ((dragEndDetails.primaryVelocity ?? 0) > 0) {
              // Page backwards
              //_goBack();
              widget.onChange();
            }
          }
          widget.onChange();
        },
        onHorizontalDragDown: (panDetails) {
          setState(() {
            currentPos = panDetails.globalPosition.dx;
            double value = 0;
            double percentage = 0;
            value = getWidth() / getHorizontalSize(305);
            if (center > currentPos) {
              percentage = 50 - (value * 100);
              widget.question.code = widget.question.agree != null
                  ? widget.question.agree?.code.toString() ?? ''
                  : "D";
            } else {
              percentage = 50 + (value * 100);
              widget.question.code = widget.question.disagree != null
                  ? widget.question.disagree?.code.toString() ?? ''
                  : "A";
            }

            widget.question.percentage = percentage.toInt();
            if (widget.question.percentage == 50) {
              widget.question.code = widget.question.agree != null
                  ? widget.question.agree?.code.toString() ?? ''
                  : "A";
            }
          });

          widget.onChange();
        },
        onPanStart: (panDetails) {
          log("pan Start");
          startHorizontalDragDetails = panDetails;
          if (startHorizontalDragDetails != null) {
            setState(() {
              currentPos = startHorizontalDragDetails!.globalPosition.dx;
              double value = 0;
              double percentage = 0;
              value = getWidth() / getHorizontalSize(305);
              if (center > currentPos) {
                percentage = 50 - (value * 100);
                widget.question.code = widget.question.agree != null
                    ? widget.question.agree?.code.toString() ?? ''
                    : "D";
              } else {
                percentage = 50 + (value * 100);
                widget.question.code = widget.question.disagree != null
                    ? widget.question.disagree?.code.toString() ?? ''
                    : "A";
              }

              widget.question.percentage = percentage.toInt();
              if (widget.question.percentage == 50) {
                widget.question.code = widget.question.agree != null
                    ? widget.question.agree?.code.toString() ?? ''
                    : "A";
              }
            });
          }
          widget.onChange();
        },
        onPanEnd: (panDetails) {
          log("pan rnd");
          if (startHorizontalDragDetails != null &&
              updateHorizontalDragDetails != null) {
            // double dx = updateHorizontalDragDetails!.globalPosition.dx -
            //     startHorizontalDragDetails!.globalPosition.dx;
            if ((panDetails.primaryVelocity ?? 0) > 0) {
              // Page forwards
            } else if ((panDetails.primaryVelocity ?? 0) > 0) {
              // Page backwards
              //_goBack();
              widget.onChange();
            }
          }
          widget.onChange();
        },
        onPanUpdate: (dragDetails) {
          updateHorizontalDragDetails = dragDetails;
          if (updateHorizontalDragDetails != null) {
            setState(() {
              currentPos = updateHorizontalDragDetails!.globalPosition.dx;

              double value = 0;
              double percentage = 0;
              value = getWidth() / getHorizontalSize(305);
              if (center > currentPos) {
                percentage = 50 - (value * 100);
                widget.question.code = widget.question.agree != null
                    ? widget.question.agree?.code.toString() ?? ''
                    : "D";
              } else {
                percentage = 50 + (value * 100);
                widget.question.code = widget.question.disagree != null
                    ? widget.question.disagree?.code.toString() ?? ''
                    : "A";
              }

              widget.question.percentage = percentage.toInt();
              if (widget.question.percentage == 50) {
                widget.question.code = widget.question.agree != null
                    ? widget.question.agree?.code.toString() ?? ''
                    : "A";
              }
            });
          }
          widget.onChange();
        },
        child: child,
      );
    }

    if (previousText.isEmpty || previousText != widget.question.question) {
      setState(() {
        _controller2!.reverse().then((value) => _controller2!.forward());
        previousText = widget.question.question;
      });
    }

    return Container(
      margin: getMargin(top: 29),
      child: Column(
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(
                CurvedAnimation(parent: _controller2!, curve: Curves.easeOut)),
            child: Container(
              width: getHorizontalSize(315),
              margin: getMarginOrPadding(left: 30, right: 30),
              color: Colors.transparent,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ClipPath(
                      clipper: BackgroundDraw(),
                      child: Container(
                        height: height,
                        width: getHorizontalSize(305),
                        color: AppColors.black900.withOpacity(0.4),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: CustomSliderGestureWidget(
                      child: Container(
                        height: height,
                        color: Colors.transparent,
                        width: getHorizontalSize(305),
                        child: Stack(
                          children: [
                            Align(
                              alignment: center < currentPos
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              child: SizedBox(
                                width: center < currentPos
                                    ? getHorizontalSize(305)
                                    : getHorizontalSize(305) / 2,
                                child: Row(
                                  mainAxisAlignment: center < currentPos
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  children: [
                                    ClipPath(
                                      clipper: CustomTriangleClipper(
                                        type: center < currentPos ? 0 : 1,
                                        trackHeight: getWidth() * fact,
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: center < currentPos
                                              ? getHorizontalSize(305) / 2
                                              : 0,
                                        ),
                                        width: getWidth(),
                                        color: AppColors.tealA400,
                                        height: getHeight(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomSliderGestureWidget(
                    child: slidingPointer(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: getPadding(top: 10),
            child: Text(
              "YOUR ANSWER",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsItalic14,
            ),
          ),
          Padding(
            padding: getPadding(top: 10),
            child: Text(
              widget.question.percentage == -1
                  ? "Neutral"
                  : widget.question.percentage < 50
                      ? "Agree"
                      : widget.question.percentage > 50
                          ? "Disagree"
                          : "Neutral",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsMedium20,
            ),
          ),
        ],
      ),
    );
  }

  int getActualValue(int percentage) {
    if (percentage < 50) {
      return 100 - percentage;
    } else if (percentage > 50) {
      return percentage;
    }
    return 50;
  }

  double getHeight() {
    return height;
  }

  double getWidth() {
    if (getHorizontalSize(305) / 2 > (currentPos - center).abs()) {
      return (currentPos - center).abs();
    }
    return getHorizontalSize(305) / 2;
  }

  Widget slidingPointer() {
    return Container(
      margin: EdgeInsets.only(
        left: center < currentPos
            ? (getHorizontalSize(306) / 2) + getWidth()
            : (getHorizontalSize(306) / 2) - getWidth(),
        top: height / 2 - getVerticalSize(21 / 2),
      ),
      height: getVerticalSize(21),
      width: getHorizontalSize(9),
      decoration: BoxDecoration(
        color: AppColors.tealA400,
        borderRadius: BorderRadius.all(Radius.circular(getSize(50))),
        boxShadow: [
          BoxShadow(
            color: AppColors.black90026,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  int type;
  double trackHeight = 0;

  CustomTriangleClipper({required this.type, required this.trackHeight});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (type == 0) {
      path.moveTo(getHorizontalSize(305) / 2, (size.height / 2));
      path.lineTo(size.width, (size.height / 2) - trackHeight);
      path.lineTo(size.width, (size.height / 2) + trackHeight);
      path.lineTo(getHorizontalSize(305) / 2, size.height / 2);
    }
    if (type == 1) {
      path.moveTo(size.width, size.height / 2);
      path.lineTo(0, size.height / 2 + trackHeight);
      path.lineTo(0, size.height / 2 - trackHeight);
      path.lineTo(size.width, size.height / 2);
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BackgroundDraw extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height / 2);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
