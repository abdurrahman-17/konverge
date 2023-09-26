import 'package:flutter/material.dart';

import '../../utilities/colors.dart';
import '../../utilities/styles/common_styles.dart';
import 'cometchat_templates.dart';
import 'cometchat_user_list.dart';

Widget floatingButton(context) {
  return FloatingActionButton(
    backgroundColor: AppColors.floatingButton,
    child: Icon(
      Icons.message_outlined,
      color: AppColors.floatingButtonForeground,
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Container(
            decoration: commonBgBackgroundGradient,
            child: usersList(
              context,
              templateInfo(),
            ),
          ),
        ),
      );
    },
  );
}
