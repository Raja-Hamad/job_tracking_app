import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/interview_questions_controller.dart';
import 'package:job_tracking_app/models/interview_questions.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class InterviewQuestions extends StatefulWidget {
  const InterviewQuestions({super.key});

  @override
  State<InterviewQuestions> createState() => _InterviewQuestionsState();
}

class _InterviewQuestionsState extends State<InterviewQuestions>
    with SingleTickerProviderStateMixin {
    final  InterviewQuestionsController _interviewQuestionsController=Get.put(InterviewQuestionsController());
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }
 
  List<InterviewQuestion> questions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Common Interview\nQuestions",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10,),
              Obx((){
                return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonFormField<String>(
        value: _interviewQuestionsController.selectedSkillFilter.value.isNotEmpty
            ? _interviewQuestionsController.selectedSkillFilter.value
            : null,
        decoration: InputDecoration(
          labelText: "Filter by Skill",
          labelStyle: GoogleFonts.poppins(),
          border: InputBorder.none,
        ),
        items: ["All", "Flutter", "React Native", "react js", "Graphic Designing"]
            .map((skill) => DropdownMenuItem(
                  value: skill == "All" ? '' : skill,
                  child: Text(skill, style: GoogleFonts.poppins()),
                ))
            .toList(),
        onChanged: (value) {
          _interviewQuestionsController.selectedSkillFilter.value = value!;
        },
      ),
    );
              }),
              const SizedBox(height: 30),
              Expanded(
                child: StreamBuilder<List<InterviewQuestion>>(
                  stream:
                     _interviewQuestionsController.filteredQuestionsStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return jobShimmerItem();
                        },
                      );
                    }
                    questions =
                        snapshot.data!;
                    if (questions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/json/nothing_found.json",
                              height: 200,
                              width: 200,
                              repeat: true,
                              fit: BoxFit.cover,
                              controller: animationController,
                              onLoaded: (composition) {
                                animationController.duration =
                                    composition.duration;
                                animationController.repeat();
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "No interview Questions found.",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final question = questions[index];
                       return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            // ignore: deprecated_member_use
                            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              unselectedWidgetColor: AppColors.primary,
                              colorScheme: Theme.of(context).colorScheme.copyWith(
                                    primary: AppColors.primary,
                                  ),
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              title: Text(
                                question.question,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              children: [
                                Text(
                                  question.answer,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget jobShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20, width: 150, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Container(height: 14, width: 100, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Container(
              height: 14,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
