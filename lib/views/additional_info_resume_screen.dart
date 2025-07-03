import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/views/premium_resume_templates_screen.dart';
import 'package:job_tracking_app/widgets/multiline_text_field_widget.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';

class AdditionalResumeInfoScreen extends StatefulWidget {
  final List<Map<String, TextEditingController>> educationListData;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final String dob;
  final List<Map<String, TextEditingController>> workList;

  const AdditionalResumeInfoScreen({
    super.key,
    required this.address,
    required this.dob,
    required this.email,
    required this.gender,
    required this.name,
    required this.phone,
    required this.educationListData,
    required this.workList,
  });
  @override
  State<AdditionalResumeInfoScreen> createState() =>
      _AdditionalResumeInfoScreenState();
}

class _AdditionalResumeInfoScreenState
    extends State<AdditionalResumeInfoScreen> {
  final TextEditingController objectiveController = TextEditingController();
  final List<TextEditingController> skillsControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> languagesControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> certificationsControllers = [
    TextEditingController(),
  ];
  final List<Map<String, TextEditingController>> projects = [
    {'title': TextEditingController(), 'description': TextEditingController()},
  ];

  void addSkill() =>
      setState(() => skillsControllers.add(TextEditingController()));
  void addLanguage() =>
      setState(() => languagesControllers.add(TextEditingController()));
  void addCertification() =>
      setState(() => certificationsControllers.add(TextEditingController()));
  void addProject() => setState(() {
    projects.add({
      'title': TextEditingController(),
      'description': TextEditingController(),
    });
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Additional Resume Info", style: GoogleFonts.poppins()),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Career Objective"),
            MultilineTextFieldWidget(
              controller: objectiveController,
              label: "Objective",
            ),
            const SizedBox(height: 20),

            _sectionTitle("Skills"),
            ...skillsControllers.map(
              (controller) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFieldWidget(
                  controller: controller,
                  isPassword: false,
                  label: "Enter a skill (e.g. Flutter, Firebase)",
                ),
              ),
            ),
            _addButton("Add Skill", addSkill),

            const SizedBox(height: 20),
            _sectionTitle("Languages"),
            ...languagesControllers.map(
              (controller) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFieldWidget(
                  controller: controller,
                  isPassword: false,
                  label: "Enter a language (e.g. English, Urdu)",
                ),
              ),
            ),
            _addButton("Add Language", addLanguage),

            const SizedBox(height: 20),
            _sectionTitle("Certifications"),
            ...certificationsControllers.map(
              (controller) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFieldWidget(
                  controller: controller,
                  isPassword: false,
                  label: "Enter a certification",
                ),
              ),
            ),
            _addButton("Add Certification", addCertification),

            const SizedBox(height: 20),
            _sectionTitle("Projects"),
            ...projects.map((project) {
              int index = projects.indexOf(project);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Project ${index + 1}",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    controller: project['title']!,
                    isPassword: false,
                    label: "Project Title",
                  ),
                  const SizedBox(height: 10),
                  MultilineTextFieldWidget(
                    controller: project['description']!,
                    label: "Project Description",
                  ),
                  const Divider(thickness: 1),
                ],
              );
            }),
            _addButton("Add Project", addProject),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Extract skills, languages, certifications
                  final List<String> skills =
                      skillsControllers
                          .where(
                            (controller) => controller.text.trim().isNotEmpty,
                          )
                          .map((controller) => controller.text.trim())
                          .toList();

                  final List<String> languages =
                      languagesControllers
                          .where(
                            (controller) => controller.text.trim().isNotEmpty,
                          )
                          .map((controller) => controller.text.trim())
                          .toList();

                  final List<String> certifications =
                      certificationsControllers
                          .where(
                            (controller) => controller.text.trim().isNotEmpty,
                          )
                          .map((controller) => controller.text.trim())
                          .toList();

                  // Extract projects as title + description combined
                  final List<String> projectDescriptions =
                      projects
                          .where(
                            (project) =>
                                project['title']!.text.trim().isNotEmpty ||
                                project['description']!.text.trim().isNotEmpty,
                          )
                          .map(
                            (project) =>
                                "${project['title']!.text.trim()}: ${project['description']!.text.trim()}",
                          )
                          .toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PremiumResumeTemplatesScreen(
                            projects1:projects,
                            workList: widget.workList,
                            name: widget.name,
                            email: widget.email,
                            phone: widget.phone,
                            address: widget.address,
                            gender: widget.gender,
                            dob: widget.dob,
                            educationListData: widget.educationListData,
                            objective: objectiveController.text.trim(),

                            skills: skills,
                            projects: projectDescriptions,
                            languages: languages,
                            certifications: certifications,
                          ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  "Finish",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  Widget _addButton(String label, VoidCallback onTap) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onTap,
        child: Text(label, style: TextStyle(color: AppColors.primary)),
      ),
    );
  }
}
