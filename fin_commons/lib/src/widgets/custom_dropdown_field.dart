import 'package:control_style/control_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../app_colors.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.name,
    required this.items,
    this.label,
    this.hintText,
    this.validator,
    this.onChanged,
    this.initialValue,
  });
  final String name;
  final String? label;
  final String? hintText;
  final List<DropdownMenuItem<dynamic>> items;
  final String? Function(dynamic)? validator;
  final void Function(dynamic)? onChanged;
  final dynamic initialValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: name,
      items: items,
      validator: validator,
      onChanged: onChanged,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        fillColor: AppColors.whiteColor,
        filled: false,
        counter: const Offstage(),
        focusedBorder: DecoratedInputBorder(
          child: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
        ),
        enabledBorder: DecoratedInputBorder(
          child: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
        ),
        disabledBorder: DecoratedInputBorder(
          child: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
        ),
        border: DecoratedInputBorder(
          child: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
        ),
        errorBorder: DecoratedInputBorder(
          child: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.errorColor,
            ),
          ),
        ),
        errorStyle: const TextStyle(
          color: AppColors.errorColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w700),
        labelStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
