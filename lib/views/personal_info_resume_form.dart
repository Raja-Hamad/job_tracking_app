import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/resume_builder_controller.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/views/edu_info_resume.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';

class PersonalInfoResumeForm extends StatefulWidget {
  const PersonalInfoResumeForm({super.key});

  @override
  State<PersonalInfoResumeForm> createState() => _PersonalInfoResumeFormState();
}

class _PersonalInfoResumeFormState extends State<PersonalInfoResumeForm> {
  ResumeBuilderController resumeBuilderController = Get.put(
    ResumeBuilderController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personal Information",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildLabel("Enter name"),
                    TextFieldWidget(
                      controller: resumeBuilderController.nameController.value,
                      isPassword: false,
                      label: "Enter your name",
                    ),
                    const SizedBox(height: 20),
                    buildLabel("Enter Email"),
                    TextFieldWidget(
                      controller: resumeBuilderController.emailController.value,
                      isPassword: false,
                      label: "Enter your email",
                    ),
                    const SizedBox(height: 20),
                    buildLabel("Enter Phone"),
                    TextFieldWidget(
                      controller: resumeBuilderController.phoneController.value,
                      isPassword: false,
                      label: "Enter your phone",
                    ),
                    const SizedBox(height: 20),
                    buildLabel("Enter Address"),
                    TextFieldWidget(
                      controller:
                          resumeBuilderController.addressController.value,
                      isPassword: false,
                      label: "Enter your address",
                    ),
                    const SizedBox(height: 20),
                    buildLabel("Select Gender"),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonFormField<String>(
                          value:
                              resumeBuilderController
                                      .selectedGender
                                      .value
                                      .isNotEmpty
                                  ? resumeBuilderController.selectedGender.value
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
                                  child: Text(
                                    gender,
                                    style: GoogleFonts.poppins(),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            resumeBuilderController.selectedGender.value =
                                value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildLabel("Select Date Of Birth"),
                    const SizedBox(height: 8),
                    Obx(
                      () => GestureDetector(
                        onTap: () => resumeBuilderController.pickDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                resumeBuilderController.dob.value.isEmpty
                                    ? "Select Date of Birth"
                                    : resumeBuilderController.dob.value,
                                style: GoogleFonts.poppins(
                                  color:
                                      resumeBuilderController.dob.value.isEmpty
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
                    const SizedBox(
                      height: 80,
                    ), // some spacing before the bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (resumeBuilderController.nameController.value.text.isEmpty ||
                    resumeBuilderController
                        .emailController
                        .value
                        .text
                        .isEmpty ||
                    resumeBuilderController
                        .phoneController
                        .value
                        .text
                        .isEmpty ||
                    resumeBuilderController
                        .addressController
                        .value
                        .text
                        .isEmpty ||
                    resumeBuilderController.selectedGender.value.isEmpty ||
                    resumeBuilderController.dob.value.isEmpty) {
                  FlushBarMessages.errorMessageFlushBar(
                    "Kindly fill all the fields",
                    context,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EduInfoResume(
                            email:
                                resumeBuilderController
                                    .emailController
                                    .value
                                    .text
                                    .toString(),
                            phone:
                                resumeBuilderController
                                    .phoneController
                                    .value
                                    .text
                                    .toString(),
                            address:
                                resumeBuilderController
                                    .addressController
                                    .value
                                    .text
                                    .toString(),
                            name:
                                resumeBuilderController
                                    .nameController
                                    .value
                                    .text
                                    .toString(),
                            dob:
                                resumeBuilderController.dob.value
                                    .trim()
                                    .toString(),
                            gender:
                                resumeBuilderController.selectedGender.value
                                    .trim()
                                    .toString(),
                          ),
                    ),
                  );
                }
              },
              child: Text(
                "Next",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
