import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/resume_controller.dart';
import 'package:job_tracking_app/models/resumes_model.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/views/personal_info_resume_form.dart';
import 'package:job_tracking_app/views/resume_pdf_viewer.dart';
import 'package:job_tracking_app/widgets/interstitial_ad_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class AllResumes extends StatefulWidget {
  const AllResumes({super.key});

  @override
  State<AllResumes> createState() => _AllResumesState();
}

class _AllResumesState extends State<AllResumes>
    with SingleTickerProviderStateMixin {
  ResumeController resumeController = Get.put(ResumeController());
  List<ResumesModel> allResumes = [];
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonalInfoResumeForm()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Resumes",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection("resumes")
                          .where(
                            "userId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                          )
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return jobShimmerItem();
                        },
                      );
                    }
                    allResumes =
                        snapshot.data!.docs
                            .map((json) => ResumesModel.fromMap(json.data()))
                            .toList();
                    if (allResumes.isEmpty) {
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
                              "No resumes found.",
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
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: allResumes.length,
                        itemBuilder: (context, index) {
                          final resume = allResumes[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return dialogWidget(
                                          context,
                                          resume.id.toString(),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => ResumePdfViewer(
                                                    pdfUrl: resume.downloadUrl,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.picture_as_pdf,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              resume.fileName,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: () async {
                                          await resumeController.downloadPdf(
                                            resume.downloadUrl,
                                            resume.fileName,
                                            context,
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Download",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

Widget dialogWidget(BuildContext context, String resumeId) {
  return AlertDialog(
    title: Text(
      "Delete Resume.",
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Text(
      "Are you sure want to delete this Resume?",
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    actions: [
      Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () async {
              try {
                await FirebaseFirestore.instance
                    .collection("resumes")
                    .doc(resumeId)
                    .delete();

                // First close the dialog
                // ignore: use_build_context_synchronously
                Navigator.pop(context);

                InterstitialAdHelper.showInterstitialAd();

                // Then show flushbar after popping dialog
                Future.delayed(Duration(milliseconds: 100), () {
                  FlushBarMessages.successMessageFlushBar(
                    "Resume deleted successfully",
                    // ignore: use_build_context_synchronously
                    context,
                  );
                });
              } catch (e) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                Future.delayed(Duration(milliseconds: 100), () {
                  FlushBarMessages.errorMessageFlushBar(
                    "Error while deleting the resume: ${e.toString()}",
                    // ignore: use_build_context_synchronously
                    context,
                  );
                });
              }
            },
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Center(
                  child: Text(
                    "OK",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
