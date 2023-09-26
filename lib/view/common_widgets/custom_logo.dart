import 'dart:io';

import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'loader_with_logo.dart';

class CustomLogo extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  final String? url;

  ///[imagePath] is required parameter for showing png,jpg,etc image
  final String? imagePath;

  ///[svgPath] is required parameter for showing svg image
  final String? svgPath;

  ///[file] is required parameter for fetching image file
  final File? file;
  final double? height, width;
  final String logo;

  final Color? color;
  final BoxFit? fit;
  final String placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final ColorFilter? colorFilter;
  final double opacity;

  CustomLogo({
    super.key,
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.color,
    this.colorFilter,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.opacity = 1,
    this.placeHolder = Assets.imgNotFound,
    this.logo = '',
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  Widget _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  Widget _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath != '') {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(
          svgPath.toString(),
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          color: color,
          colorFilter: colorFilter,
        ),
      );
    } else if (file != null && file?.path != '') {
      return Image.file(
        file!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    } else if (url != null && url != '') {
      return CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageUrl: url.toString(),
        color: color,
        placeholder: (context, url) => SizedBox(
          height: 30,
          width: 30,
          child: LoaderWithLogo(),
        ),
        errorWidget: (context, url, error) => Image.asset(
          placeHolder,
          height: (height ?? 30),
          width: (width ?? 30),
          fit: fit ?? BoxFit.contain,
          color: AppColors.tealA400,
        ),
      );
    } else if (imagePath != null && imagePath != '') {
      return Image.asset(
        imagePath.toString(),
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        opacity: AlwaysStoppedAnimation(opacity),
      );
    }
    return const SizedBox();
  }

// @override
// Widget build(BuildContext context) {
//   return Image.asset(
//     logo,
//     height: height ?? 120.w,
//     width: width ?? 120.w,
//   );
// }
}
