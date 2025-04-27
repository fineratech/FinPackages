import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../my_utils.dart';

class CustomImage extends StatefulWidget {
  const CustomImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.height = double.infinity,
    this.shimmerRadius = 5,
    this.width,
    this.color,
    this.backgroundColor,
    this.borderRadius = 0,
    this.matchTextDirection = false,
    this.isIcon = false,
    this.showShimmer = true,
    this.onErrorBackgroundColor,
    this.bodyColor,
    this.coverColor,
    this.errorWidget,
    this.placeHolderImage,
    this.isProfileView = false,
    this.userName,
    this.initialsTextStyle,
  });

  final String imagePath;
  final BoxFit fit;
  final double height;
  final double? width;
  final double shimmerRadius;
  final Color? color;
  final Color? backgroundColor;
  final double borderRadius;
  final bool matchTextDirection;
  final bool isIcon;
  final bool showShimmer;
  final Color? onErrorBackgroundColor;
  final Widget? errorWidget;

  final Color? bodyColor;
  final Color? coverColor;
  final String? placeHolderImage;
  final bool? isProfileView; // for 'My Profile' and 'Profile Details' screen
  final String? userName; // for 'My Profile' and 'Profile Details' screen
  final TextStyle? initialsTextStyle;
  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  late String latestImagePath = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if ((widget.imagePath.startsWith('http') ||
            widget.imagePath.startsWith('https') ||
            widget.imagePath.startsWith('www.')) &&
        widget.imagePath.contains(".svg")) {
      latestImagePath = Utils.removeQueryParamsFromUrl(widget.imagePath);
    } else {
      latestImagePath = widget.imagePath;
    }

    return _getImageView(size, context, errorWidget: widget.errorWidget);
  }

  _getImageView(Size size, BuildContext context, {Widget? errorWidget}) {
    return _getImageWidget(latestImagePath, size, context,
        errorWidget: errorWidget);
  }

  Widget _getImageWidget(String path, Size size, BuildContext context,
      {Widget? errorWidget}) {
    if (path.startsWith('http') ||
        path.startsWith('https') ||
        path.startsWith('www.')) {
      if (path.endsWith("svg")) {
        return SvgPicture.network(
          path,
          fit: widget.fit,
          width: widget.width ?? size.width,
          height: widget.height,
          color: widget.color,
          cacheColorFilter: true,
          matchTextDirection: widget.matchTextDirection,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: path,
          width: widget.width ?? size.width,
          height: widget.height,
          fit: widget.fit,
          matchTextDirection: widget.matchTextDirection,
          // placeholder: (context, url) => path.isEmpty
          //     ? SvgPicture.asset(
          //         widget.placeHolderImage ?? SVGIcons.logo,
          //         fit: BoxFit.contain,
          //         color: Colors.blue,
          //       )
          //     : Container(),
        );
      }
    } else if (path.endsWith("svg")) {
      return SvgPicture.asset(
        path,
        fit: widget.fit,
        width: widget.width ?? size.width,
        height: widget.height,
        color: widget.color,
        matchTextDirection: widget.matchTextDirection,
      );
    } else {
      return Image.asset(
        path,
        fit: widget.fit,
        width: widget.width ?? size.width,
        height: widget.height,
        matchTextDirection: widget.matchTextDirection,
      );
    }
  }
}
