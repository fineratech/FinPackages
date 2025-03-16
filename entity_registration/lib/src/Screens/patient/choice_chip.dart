import 'package:entity_registration/src/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });
  final String label;
  final bool selected;
  final void Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: selected ? AppColors.whiteColor : AppColors.primaryColor,
        ),
      ),
      selected: selected,
      onSelected: (value) {
        onSelected(value);
      },
      selectedColor: AppColors.primaryColor,
      side: const BorderSide(
        color: AppColors.primaryColor,
      ),
      backgroundColor: AppColors.whiteColor,
    );
  }
}
