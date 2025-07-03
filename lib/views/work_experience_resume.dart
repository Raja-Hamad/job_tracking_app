import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/views/additional_info_resume_screen.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';

class WorkExperienceResume extends StatefulWidget {
  final List<Map<String, TextEditingController>> educationListData;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final String dob;

  WorkExperienceResume({
    super.key,
    required this.address,
    required this.dob,
    required this.email,
    required this.gender,
    required this.name,
    required this.phone,
    required this.educationListData,
  });

  @override
  State<WorkExperienceResume> createState() => _WorkExperienceResumeState();
}

class _WorkExperienceResumeState extends State<WorkExperienceResume> {
  final List<Map<String, TextEditingController>> workList = [];

  @override
  void initState() {
    super.initState();
    _addWorkField();

    if (kDebugMode) {
      print("The education data is ${widget.educationListData.length}");
    }
  }

  void _addWorkField() {
    workList.add({
      "jobTitle": TextEditingController(),
      "company": TextEditingController(),
      "startYear": TextEditingController(),
      "endYear": TextEditingController(),
    });
    setState(() {});
  }

  void _removeWorkField(int index) {
    workList.removeAt(index);
    setState(() {});
  }

  Widget _buildWorkField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Work Experience ${index + 1}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: workList[index]["jobTitle"]!,
          isPassword: false,
          label: "Job Title (e.g. Flutter Developer)",
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: workList[index]["company"]!,
          isPassword: false,
          label: "Company Name",
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(
                controller: workList[index]["startYear"]!,
                isPassword: false,
                label: "Start Year (e.g. 2022)",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldWidget(
                controller: workList[index]["endYear"]!,
                isPassword: false,
                label: "End Year (e.g. 2024)",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (workList.length > 1)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _removeWorkField(index),
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
            ...List.generate(workList.length, _buildWorkField),
            ElevatedButton(
              onPressed: _addWorkField,
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
                if (workList.isEmpty) {
                  FlushBarMessages.errorMessageFlushBar(
                    "Please add at least one work experience entry.",
                    context,
                  );
                  return;
                }

                for (int i = 0; i < workList.length; i++) {
                  final job = workList[i]["jobTitle"]!.text.trim();
                  final company = workList[i]["company"]!.text.trim();
                  final start = workList[i]["startYear"]!.text.trim();
                  final end = workList[i]["endYear"]!.text.trim();

                  if (job.isEmpty ||
                      company.isEmpty ||
                      start.isEmpty ||
                      end.isEmpty) {
                    FlushBarMessages.errorMessageFlushBar(
                      "Please complete all fields in Work Experience ${i + 1}.",
                      context,
                    );
                    return;
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AdditionalResumeInfoScreen(
                          workList: workList,
                          name: widget.name,
                          email: widget.email,
                          phone: widget.phone,
                          address: widget.address,
                          gender: widget.gender,
                          dob: widget.dob,
                          educationListData: widget.educationListData,
                        ),
                  ),
                );
                FlushBarMessages.successMessageFlushBar(
                  "All work experience validated successfully.",
                  context,
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
