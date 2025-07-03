import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatefulWidget {
  String label;
  TextEditingController controller;
  bool isPassword;
  IconButton? suffixIcon;
    final Function(String)? onChanged;

  TextFieldWidget({
    super.key,
    required this.controller,
    required this.isPassword,
    required this.label,
    this.suffixIcon,
        this.onChanged, // 👈 Accept the callback

  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword,
      cursorColor: AppColors.primary,
            onChanged: widget.onChanged,

      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon ?? null,
        labelText: widget.label,
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
