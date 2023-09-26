import 'package:flutter/material.dart';
import '../common_widgets/loader_with_logo.dart';

import '../../main.dart';
import '../../utilities/size_utils.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          width: getSize(60),
          height: getSize(60),
          child: LoaderWithLogo(),
        ),
      ),
    );
  }
}

///progress dialogue with content
void progressDialogue({String? content}) {
  AlertDialog alert = AlertDialog(
    key: const ObjectKey('loader'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: content != null ? Colors.white : Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(
                MediaQuery.of(globalNavigatorKey.currentContext!).size.width *
                    0.05),
            child: content != null
                ? Row(
                    children: [
                      Flexible(
                        child: Text(content),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    ],
                  )
                : const Loader(),
          ),
        ),
      ],
    ),
  );
  showDialog<dynamic>(
    //prevent outside touch
    barrierDismissible: false,
    context: globalNavigatorKey.currentContext!,
    builder: (BuildContext context) {
      //prevent Back button press
      return WillPopScope(
        onWillPop: () async => false,
        child: alert,
      );
    },
  );
}
