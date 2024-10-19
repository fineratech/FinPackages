import 'package:bank_details/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.height = kToolbarHeight,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.centerTitle = true,
    this.titleSpacing,
    this.backgroundColor,
    this.foregroudColor,
    this.automaticallyImplyLeading = false,
  });
  final String title;
  final double height;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final double? titleSpacing;
  final Color? backgroundColor;
  final Color? foregroudColor;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: foregroudColor ?? AppColors.primaryColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.backgoundColor,
      elevation: 0,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: foregroudColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
