import 'package:control_style/control_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../constants/app_colors.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    required this.name,
    this.inputType = InputType.both,
    this.label,
    this.hintText,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.currentDate,
  });
  final String name;
  final String? label;
  final String? hintText;
  final InputType inputType;
  final String? Function(DateTime?)? validator;
  final void Function(DateTime?)? onChanged;
  final DateTime? initialValue;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? currentDate;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: name,
      inputType: inputType,
      validator: validator,
      onChanged: onChanged,
      initialDate: initialDate,
      initialValue: initialValue,
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: currentDate,
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
