import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_colors.dart';
import '../svg_icons.dart';

class UploadImage extends StatelessWidget {
  const UploadImage({
    super.key,
    this.onTap,
    this.image,
  });
  final VoidCallback? onTap;
  final File? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AppColors.lightGreyColor.withOpacity(0.6),
          shape: BoxShape.circle,
          image:
              image != null ? DecorationImage(image: FileImage(image!)) : null,
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            SvgPicture.string(
              uploadIcon,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
              width: 30,
              height: 30,
            ),
            const SizedBox(height: 10),
            const Text(
              "Upload Logo",
            ),
          ],
        ),
      ),
    );
  }
}
