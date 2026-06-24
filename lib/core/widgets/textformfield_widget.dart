import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final TextSelectionControls? selectionControls;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
    this.keyboardType,
    this.selectionControls,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    Widget textField = TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      selectionControls: selectionControls,
      onChanged: onChanged,
      validator: validator,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            size: 20,
            color: AppColors.outline.withValues(alpha: 0.5),
          ),
          onPressed: onToggleObscure,
        )
            : null,
      ),
    );

    if (label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label!.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          textField,
        ],
      );
    }

    return textField;
  }
}
