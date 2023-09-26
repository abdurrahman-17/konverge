import 'package:flutter/material.dart';

import '../../utilities/title_string.dart';

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(TitleString.errorOccurred),
    );
  }
}
