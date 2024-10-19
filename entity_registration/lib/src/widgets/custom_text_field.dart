import 'package:control_style/control_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final Widget? suffix;
  final BoxConstraints? prefixConstraints;
  final BoxConstraints? suffixConstraints;
  final int? maxLines;
  final bool? obscure;
  final String? errorText;
  final double? borderRadius;
  final bool enabled;
  final double? fontSize;
  final String? label;
  final int? maxLength;
  final void Function(String?)? onSaved;
  final VoidCallback? onTap;
  final bool disableBorder;
  final void Function(String?)? onChanged;
  final TextInputAction? textInputAction;
  final void Function(String?)? onFieldSubmitted;
  final Color? fillColor;
  final Color? focusColor;
  final EdgeInsets? suffixPadding;
  final bool isReadOnly;

  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.textInputType,
    this.obscure = false,
    this.enabled = true,
    this.validator,
    this.prefix,
    this.suffix,
    this.prefixConstraints,
    this.suffixConstraints,
    this.borderRadius = 10,
    this.maxLines = 1,
    this.errorText,
    this.fontSize = 14.0,
    this.label,
    this.maxLength,
    this.onSaved,
    this.onTap,
    this.disableBorder = false,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixPadding,
    this.fillColor = AppColors.backgoundColor,
    this.focusColor = AppColors.whiteColor,
    this.isReadOnly = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _myFocusNode;
  final ValueNotifier<bool> _myFocusNotifier = ValueNotifier<bool>(false);
  bool _showErrorMessage = false;

  @override
  void initState() {
    _myFocusNode = FocusNode();
    _myFocusNode.addListener(() {
      _onFocusChange();
    });
    super.initState();
  }

  //Getters
  ValueNotifier<bool> get myFocusNotifier => _myFocusNotifier;
  FocusNode get myFocusNode => _myFocusNode;
  bool get showErrorMessage => _showErrorMessage;

  //Setters
  set showErrorMessage(bool value) {
    _showErrorMessage = value;
    setState(() {});
  }

  void _onFocusChange() {
    _myFocusNotifier.value = _myFocusNode.hasFocus;
  }

  @override
  void dispose() {
    _myFocusNode.removeListener(_onFocusChange);
    _myFocusNode.dispose();
    _myFocusNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: myFocusNotifier,
      builder: (context, isFocus, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: FormBuilderTextField(
            name: widget.hintText,
            focusNode: myFocusNode,
            onChanged: (value) {
              showErrorMessage = true;
              widget.onChanged?.call(value);
            },
            onTap: widget.onTap,
            onTapOutside: (event) {
              myFocusNode.unfocus();
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: widget.onSaved,
            cursorColor: AppColors.primaryColor,
            enabled: widget.enabled,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onFieldSubmitted,
            controller: widget.controller,
            readOnly: widget.isReadOnly,
            maxLines: widget.maxLines,
            keyboardType: widget.textInputType,
            obscureText: widget.obscure!,
            obscuringCharacter: '●',
            maxLength: widget.maxLength,
            style: TextStyle(
                fontSize: widget.fontSize,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w700),
            validator: widget.validator,
            decoration: InputDecoration(
              errorText: showErrorMessage ? widget.errorText : null,
              // contentPadding: EdgeInsets.only(top: 16, left: 16, bottom: 16),
              labelText: widget.label,
              fillColor: isFocus ? widget.focusColor : widget.fillColor,
              filled: true,
              counter: const Offstage(),
              prefixIconConstraints: widget.prefixConstraints,
              prefixIcon: widget.prefix != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: widget.prefix!,
                    )
                  : null,
              suffixIcon: widget.suffix != null
                  ? Padding(
                      padding: widget.suffixPadding ??
                          const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: widget.suffix,
                    )
                  : null,
              suffixIconConstraints: widget.suffixConstraints,
              focusedBorder: DecoratedInputBorder(
                child: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              enabledBorder: DecoratedInputBorder(
                child: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              disabledBorder: DecoratedInputBorder(
                child: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              border: DecoratedInputBorder(
                child: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              errorBorder: DecoratedInputBorder(
                child: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
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
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
              labelStyle: TextStyle(
                  color: isFocus
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
        );
      },
    );
  }
}
