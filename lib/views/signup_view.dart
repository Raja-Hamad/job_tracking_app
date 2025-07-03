import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/signup_controller.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/views/login_view.dart';
import 'package:job_tracking_app/widgets/submit_button_widget.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text(
          "Admin Register",
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Admin 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Profile Image Picker
              Center(
                child: Obx(() {
                  return InkWell(
                    onTap: signupController.pickImageFromGallery,
                    child:
                        signupController.selectedImage.value == null
                            ? CircleAvatar(
                              backgroundColor: AppColors.white,
                              radius: 40,
                              child: const Icon(Icons.camera_alt),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                40,
                              ), // Make it circular
                              child: Image.file(
                                signupController.selectedImage.value!,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                  );
                }),
              ),

              const SizedBox(height: 16),
              TextFieldWidget(
                label: "Full Name",
                controller: signupController.nameController.value,
                isPassword: false,
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                label: "Email Address",
                controller: signupController.emailController.value,
                isPassword: false,
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                label: "Password",
                controller: signupController.passwordController.value,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                label: "Address",
                controller: signupController.addressController.value,
                isPassword: false,
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                label: "Contact Number",
                controller: signupController.phoneController.value,
                isPassword: false,
              ),
              const SizedBox(height: 16),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonFormField<String>(
                    value:
                        signupController.selectedGender.value.isNotEmpty
                            ? signupController.selectedGender.value
                            : null,
                    decoration: InputDecoration(
                      labelText: "Gender",
                      labelStyle: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                    ),
                    items:
                        ["Male", "Female", "Other"].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender, style: GoogleFonts.poppins()),
                          );
                        }).toList(),
                    onChanged: (value) {
                      signupController.selectedGender.value = value!;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => GestureDetector(
                  onTap: () => signupController.pickDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          signupController.selectedDob.value.isEmpty
                              ? "Select Date of Birth"
                              : signupController.selectedDob.value,
                          style: GoogleFonts.poppins(
                            color:
                                signupController.selectedDob.value.isEmpty
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Obx(() {
                return SubmitButtonWidget(
                  isLoading: signupController.isLoading.value,
                  buttonColor: AppColors.primary,
                  title: "Register",
                  onPress: () {
                    signupController.registerAdmin(
                      image:
                          signupController.selectedImage.value != null
                              ? File(signupController.selectedImage.value!.path)
                              : null,
                      address:
                          signupController.addressController.value.text
                              .trim()
                              .toString(),
                      phone:
                          signupController.phoneController.value.text
                              .trim()
                              .toString(),
                      gender: signupController.selectedGender.value,
                      dob: signupController.selectedDob.value,
                      name:
                          signupController.nameController.value.text
                              .trim()
                              .toString(),
                      email:
                          signupController.emailController.value.text
                              .trim()
                              .toString(),
                      password:
                          signupController.passwordController.value.text
                              .trim()
                              .toString(),
                      context: context,
                    );
                  },
                );
              }),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
