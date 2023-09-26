import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    required this.textController,
    required this.onChanged,
    required this.label,
    this.suffix,
  });

  final TextEditingController textController;
  final void Function(String)? onChanged;
  final String label;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onFieldSubmitted: (value) {},
      decoration: InputDecoration(
        fillColor: const Color(0xffF1EEF5),
        filled: true,
        hintText: label,
        suffixIcon: suffix,
        prefixIcon: const Icon(
          Icons.search,
          size: 20,
          color: Color(0xffA19CAC),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffA19CAC),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffA19CAC),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
