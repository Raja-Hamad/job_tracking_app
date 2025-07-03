import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/resume_builder_controller.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/views/work_experience_resume.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';

class EduInfoResume extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final String dob;

  const EduInfoResume({
    super.key,
    required this.address,
    required this.dob,
    required this.email,
    required this.gender,
    required this.name,
    required this.phone,
  });

  @override
  State<EduInfoResume> createState() => _EduInfoResumeState();
}

class _EduInfoResumeState extends State<EduInfoResume> {
  ResumeBuilderController resumeBuilderController = Get.put(
    ResumeBuilderController(),
  );
  final List<Map<String, TextEditingController>> educationList = [];

  @override
  void initState() {
    super.initState();
    _addEducationField();
  }

  void _addEducationField() {
    educationList.add({
      "degree": TextEditingController(),
      "institute": TextEditingController(),
      "startYear": TextEditingController(),
      "endYear": TextEditingController(),
    });
    setState(() {});
  }

  void _removeEducationField(int index) {
    educationList.removeAt(index);
    setState(() {});
  }

  Widget _buildEducationField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Education ${index + 1}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: educationList[index]["degree"]!,
          isPassword: false,
          label: "Degree (e.g. BSCS, BBA)",
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: educationList[index]["institute"]!,
          isPassword: false,
          label: "Institute Name",
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(
                controller: educationList[index]["startYear"]!,
                isPassword: false,
                label: "Start Year (e.g. 2018)",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldWidget(
                controller: educationList[index]["endYear"]!,
                isPassword: false,
                label: "End Year (e.g. 2022)",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (educationList.length > 1)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _removeEducationField(index),
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ),
        const Divider(thickness: 1),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ...List.generate(educationList.length, _buildEducationField),
            ElevatedButton(
              onPressed: _addEducationField,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                "Add Another",
                style: GoogleFonts.poppins(color: Colors.white),
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
                // Ensure at least one entry
                if (educationList.isEmpty) {
                  FlushBarMessages.errorMessageFlushBar(
                    "Please add at least one education entry.",
                    context,
                  );
                  return;
                }

                // Validate each field in each education entry
                for (int i = 0; i < educationList.length; i++) {
                  final degree = educationList[i]['degree']!.text.trim();
                  final institute = educationList[i]['institute']!.text.trim();
                  final startYear = educationList[i]['startYear']!.text.trim();
                  final endYear = educationList[i]['endYear']!.text.trim();

                  if (degree.isEmpty ||
                      institute.isEmpty ||
                      startYear.isEmpty ||
                      endYear.isEmpty) {
                    FlushBarMessages.errorMessageFlushBar(
                      "Please complete all fields in Education ${i + 1}.",
                      context,
                    );
                    return;
                  }
                }

                // If all validations pass, proceed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => WorkExperienceResume(
                          name: widget.name,
                          email: widget.email,
                          phone: widget.phone,
                          address: widget.address,
                          gender: widget.gender,
                          dob: widget.dob,
                          educationListData: educationList,
                        ),
                  ),
                );
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
}
