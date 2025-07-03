
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/widgets/submit_button_widget.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';
class ForgetPasswordBottomSheet extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String buttonText;
  final VoidCallback onSubmit;

  const ForgetPasswordBottomSheet({
    super.key,
    required this.controller,
    required this.title,
    required this.buttonText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: controller,
              isPassword: false,
              label: "Enter Email Address",
            ),
            const SizedBox(height: 16),
            SubmitButtonWidget(
              buttonColor: AppColors.primary,
              title: title,
              onPress: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
