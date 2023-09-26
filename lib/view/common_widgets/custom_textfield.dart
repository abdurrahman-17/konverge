import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';

import '../../utilities/enums.dart';
import '../../utilities/styles/text_form_field_styles.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
      {super.key,
      this.padding,
      this.shape,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      required this.focusNode,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.maxLength,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.onChanged,
      this.onCountryChanged,
      this.countryCode,
      this.suffixConstraints,
      this.validator,
      this.hintStyle,
      this.counterText,
      this.isEnabled = true,
      this.autoFocus = false,
      this.onSubmitted,
      this.inputFormatters,
      this.isNotDispose = false,
      this.autoValidateMode,
      this.focusedInputBorder,
      this.textCapitalization = TextCapitalization.sentences});

  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<CountryCode>? onCountryChanged;
  CountryCode? countryCode;
  final TextFormFieldPadding? padding;
  final TextFormFieldShape? shape;
  final TextFormFieldVariant? variant;
  final TextFormFieldFontStyle? fontStyle;
  final TextFormFieldFontStyle? hintStyle;
  final Alignment? alignment;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final TextEditingController? controller;
  final FocusNode focusNode;
  bool isObscureText;
  final TextInputAction? textInputAction;
  final TextInputType textInputType;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;
  final bool autoFocus;
  final String? counterText;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final FormFieldValidator<String>? validator;
  final bool isEnabled;
  final bool isNotDispose;
  final AutovalidateMode? autoValidateMode;
  final TextFormFieldVariant? focusedInputBorder;
  final TextCapitalization textCapitalization;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  TextFormFieldStyles textFormFieldStyle = TextFormFieldStyles();
  final inputKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(listener);
  }

  void listener() {
    if (!widget.focusNode.hasFocus) {
      // log('widget.focusNode message ${inputKey.currentState?.validate()}');
      inputKey.currentState?.validate();
    }
  }

  @override
  void dispose() {
    if (!widget.isNotDispose) if (widget.controller != null)
      widget.controller?.dispose();
    widget.focusNode.removeListener(listener);
    if (!widget.isNotDispose) widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  Widget _buildTextFormFieldWidget() {
    return Container(
      width: widget.width ?? double.maxFinite,
      margin: widget.margin,
      child: TextFormField(
        onTapOutside: (val) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          widget.focusNode.requestFocus();
          widget.focusNode.unfocus();
          print("focus sttaus2 ${widget.focusNode.hasFocus}");
          //   FocusManager.instance.primaryFocus?.unfocus();
        },
        key: inputKey,
        obscuringCharacter: '●',
        onEditingComplete: () {
          if (widget.textInputAction != TextInputAction.next) {
            //  widget.focusNode.unfocus();
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            widget.focusNode.requestFocus();
            widget.focusNode.unfocus();
          } else {
            widget.focusNode.requestFocus();
            //  widget.focusNode.unfocus();
            FocusScope.of(context).nextFocus();
          }
          //print("focus sttaus ${widget.focusNode.hasFocus}");
        },
        inputFormatters: widget.inputFormatters,
        enabled: widget.isEnabled,
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        style: textFormFieldStyle.setFontStyle(widget.fontStyle),
        obscureText: widget.isObscureText,
        textInputAction: widget.textInputAction,
        keyboardType: widget.textInputType,
        maxLines: widget.maxLines ?? 1,
        textCapitalization: widget.textInputType == TextInputType.emailAddress
            ? TextCapitalization.none
            : TextCapitalization.sentences,
        maxLength: widget.maxLength,
        autofocus: widget.autoFocus,
        autovalidateMode:
            widget.autoValidateMode ?? AutovalidateMode.onUserInteraction,
        decoration: textFormFieldStyle.buildDecoration(
          isEnabled: widget.isEnabled,
          hintText: widget.hintText,
          focusedInputBorder:
              widget.focusedInputBorder ?? TextFormFieldVariant.outlineTealA400,
          counterText: widget.counterText ?? "",
          prefix: widget.textInputType == TextInputType.phone
              ? InkWell(
                  onTap: () {},
                  child: CountryCodePicker(
                    onChanged: (value) {
                      if (widget.onCountryChanged != null) {
                        widget.onCountryChanged!(value);
                        widget.countryCode = value;
                      }
                    },
                    showFlagMain: true,
                    hideMainText: true,
                    padding: getMargin(left: 12),
                    flagWidth: getHorizontalSize(20),
                    dialogSize: Size(
                      getHorizontalSize(900),
                      getVerticalSize(800),
                    ),
                    boxDecoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: "GB",
                    favorite: const ['+44', 'GB'],
                    //countryFilter: const ['IT', 'FR'],
                    // flag can be styled with BoxDecoration's `borderRadius` and `shape` fields
                  ))
              : widget.prefix,
          suffix: widget.textInputType == TextInputType.visiblePassword
              ? InkWell(
                  onTap: () {
                    setState(() {
                      widget.isObscureText = !widget.isObscureText;
                    });
                  },
                  hoverColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  focusColor: AppColors.transparent,
                  splashColor: AppColors.transparent,
                  onLongPress: () {
                    setState(() {
                      widget.isObscureText = !widget.isObscureText;
                    });
                  },
                  child: Padding(
                    padding:
                        getPadding(left: 5, top: 12, right: 25, bottom: 12),
                    child: CustomLogo(
                      svgPath: widget.isObscureText
                          ? Assets.imgVisible
                          : Assets.imgHide,
                    ),
                  ),
                )
              : widget.suffix,
          prefixConstraints:
              widget.textInputType == TextInputType.visiblePassword
                  ? BoxConstraints(
                      maxHeight: getVerticalSize(29),
                      maxWidth: getHorizontalSize(30),
                    )
                  : widget.prefixConstraints,
          suffixConstraints:
              widget.textInputType == TextInputType.visiblePassword
                  ? BoxConstraints(
                      maxHeight: getVerticalSize(47),
                    )
                  : widget.suffixConstraints,
          shape: widget.shape,
          padding: widget.textInputType == TextInputType.phone
              ? TextFormFieldPadding.paddingT0
              : widget.padding,
          variant: widget.variant,
          hintStyle: widget.hintStyle ?? widget.fontStyle,
        ),
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
      ),
    );
  }
}
