import 'package:flutter/material.dart';

import '../enums.dart';

class PageTransition {
  PageRouteBuilder getTransition(
      {required Widget widget,
      PageTransitionTypes transitionType = PageTransitionTypes.rightToLeft,
      int? time}) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionDuration: Duration(
            milliseconds: time != null
                ? time
                : transitionType == PageTransitionTypes.rightToLeft
                    ? 800
                    : 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = transitionType == PageTransitionTypes.rightToLeft
              ? Offset(-1.0, 0.0)
              : Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
              textDirection: TextDirection.rtl);
        });
  }
}
