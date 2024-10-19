import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class ImageWithTitle extends StatelessWidget {
  const ImageWithTitle({
    super.key,
    this.pngPath,
    required this.title,
    this.showBorder = false,
    this.svgPath,
    this.isSelected = false,
  });
  final String? pngPath;
  final String? svgPath;
  final bool isSelected;

  final String title;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(5),
        border: showBorder
            ? Border.all(
                color: AppColors.blackColor,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pngPath != null)
            Image.asset(
              pngPath!,
              height: 50,
              width: 50,
              package: 'entity_registration',
            ),
          if (svgPath != null)
            SvgPicture.asset(
              svgPath!,
              height: 50,
              width: 50,
            ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
