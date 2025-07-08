import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/interview_questions_controller.dart';
import 'package:job_tracking_app/models/interview_questions.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/widgets/submit_button_widget.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';
import 'package:uuid/uuid.dart';

class AddInterviewQuestions extends StatefulWidget {
  const AddInterviewQuestions({super.key});

  @override
  State<AddInterviewQuestions> createState() => _AddInterviewQuestionsState();
}

class _AddInterviewQuestionsState extends State<AddInterviewQuestions> {
  final InterviewQuestionsController _interviewQuestionsController = Get.put(
    InterviewQuestionsController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Interivew Questions",
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              
              const SizedBox(height: 30),
              TextFieldWidget(
                controller:
                    _interviewQuestionsController
                        .textEditingControllerQuestion
                        .value,
                isPassword: false,
                label: "Interview Question",
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                controller:
                    _interviewQuestionsController
                        .textEditingControllerAnswer
                        .value,
                isPassword: false,
                label: "Answer",
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
                        _interviewQuestionsController.skill.value.isNotEmpty
                            ? _interviewQuestionsController.skill.value
                            : null,
                    decoration: InputDecoration(
                      labelText: "Skill",
                      labelStyle: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                    ),
                    items:
                        ["React Native", "Graphic Designing", "Flutter",'react js'].map((
                          gender,
                        ) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender, style: GoogleFonts.poppins()),
                          );
                        }).toList(),
                    onChanged: (value) {
                      _interviewQuestionsController.skill.value = value!;
                    },
                  ),
                ),
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
                        _interviewQuestionsController
                                .difficulty
                                .value
                                .isNotEmpty
                            ? _interviewQuestionsController.difficulty.value
                            : null,
                    decoration: InputDecoration(
                      labelText: "Difficulty",
                      labelStyle: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                    ),
                    items:
                        ["Easy", "Medium", "High"].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender, style: GoogleFonts.poppins()),
                          );
                        }).toList(),
                    onChanged: (value) {
                      _interviewQuestionsController.difficulty.value = value!;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Obx(
                () => Center(
                  child: SubmitButtonWidget(
                    isLoading: _interviewQuestionsController.isLoading.value,
                    buttonColor: AppColors.primary,
                    title: "Add Interview Question",
                    onPress: () {
                      InterviewQuestion model = InterviewQuestion(
                        id: Uuid().v4(),
                        skill:
                            _interviewQuestionsController.skill.value
                                .toString(),
                        question:
                            _interviewQuestionsController
                                .textEditingControllerQuestion
                                .value
                                .text
                                .toString(),
                        answer:
                            _interviewQuestionsController
                                .textEditingControllerAnswer
                                .value
                                .text
                                .toString(),
                        difficulty:
                            _interviewQuestionsController.difficulty.value
                                .toString(),
                      );

                      final createdAt = model.toMap();
                      createdAt['createdAt'] = FieldValue.serverTimestamp();

                      _interviewQuestionsController
                          .addInterviewQuestion(model, context)
                          .then((value) {
                            _interviewQuestionsController
                                .textEditingControllerAnswer
                                .value
                                .text = '';
                            _interviewQuestionsController
                                .textEditingControllerQuestion
                                .value
                                .text = '';
                            _interviewQuestionsController.difficulty.value = '';
                            _interviewQuestionsController.skill.value = '';
                          });
                    },
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
