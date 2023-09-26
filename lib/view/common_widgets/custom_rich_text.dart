import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;

  CustomRichText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.clip,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      text: TextSpan(
        text: text,
        style: style,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
