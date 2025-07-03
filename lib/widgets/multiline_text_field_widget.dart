import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';

// ignore: must_be_immutable
class MultilineTextFieldWidget extends StatefulWidget {
  String label;
  TextEditingController controller;

  MultilineTextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<MultilineTextFieldWidget> createState() => _MultilineTextFieldWidgetState();
}

class _MultilineTextFieldWidgetState extends State<MultilineTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLines: 4,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
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
