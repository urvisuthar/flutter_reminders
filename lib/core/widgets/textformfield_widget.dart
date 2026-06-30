import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/date_time_utils.dart';

class AppTextField extends StatefulWidget {
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
  final int? minLines;
  final int? maxLines;
  final bool isDatePicker;
  final bool isTimePicker;

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
    this.minLines,
    this.maxLines,
    this.isDatePicker = false,
    this.isTimePicker = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  Future<void> _onTap() async {
    if (widget.isDatePicker) {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        widget.controller.text = DateTimeUtils.toDisplayDate(picked);
        widget.onChanged?.call(DateTimeUtils.toApiDate(picked));
      }
    } else if (widget.isTimePicker) {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        final dt = DateTime(0, 0, 0, picked.hour, picked.minute);
        widget.controller.text = DateTimeUtils.toDisplayTime(dt);
        widget.onChanged?.call(DateTimeUtils.toApiTime(picked.hour, picked.minute));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPicker = widget.isDatePicker || widget.isTimePicker;

    Widget textField = TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      selectionControls: widget.selectionControls,
      onChanged: widget.onChanged,
      validator: widget.validator,
      minLines: widget.minLines,
      maxLines: widget.isPassword
          ? 1
          : (widget.maxLines ?? (widget.minLines != null ? null : 1)),
      readOnly: isPicker,
      onTap: isPicker ? _onTap : null,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                size: 20,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  widget.obscureText
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  size: 20,
                  color: AppColors.outline.withValues(alpha: 0.5),
                ),
                onPressed: widget.onToggleObscure,
              )
            : isPicker
                ? Icon(
                    widget.isDatePicker
                        ? Icons.calendar_today_outlined
                        : Icons.access_time,
                    size: 20,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  )
                : null,
      ),
    );

    if (widget.label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              widget.label!.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
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
