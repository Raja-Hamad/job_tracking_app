import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';

class SubmitButtonWidget extends StatelessWidget {
  final String title;
  final Color buttonColor;
  final VoidCallback onPress;
  final bool isLoading;

  const SubmitButtonWidget({
    super.key,
    required this.buttonColor,
    required this.title,
    required this.onPress,
    this.isLoading = false, // Optional with default value
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPress,
      child: Container(
        height: 40,
        width: 300,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
        ),
      ),
    );
  }
}
