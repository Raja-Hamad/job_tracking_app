import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/logout_controller.dart';
import 'package:job_tracking_app/models/job_model.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/utils/extensions/local_storage.dart';
import 'package:job_tracking_app/views/add_new_job.dart';
import 'package:job_tracking_app/views/job_detail_view.dart';
import 'package:job_tracking_app/widgets/banner_ad_widget.dart';
import 'package:job_tracking_app/widgets/interstitial_ad_widget.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  LogoutController logoutController = Get.put(LogoutController());
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    getValues();
  }

  LocalStorage localStorage = LocalStorage();
  String? name;
  String? email;
  String? role;
  String? adminDeviceToken;
  String? phone;

  String? imageUrl;
  getValues() async {
    name = await localStorage.getValue("userName");
    email = await localStorage.getValue("email");
    role = await localStorage.getValue("role");
    imageUrl = await localStorage.getValue("imageUrl");
    phone = await localStorage.getValue("phone");
    adminDeviceToken = await localStorage.getValue("userDeviceToken");
    if (kDebugMode) {
      print("Device Token of the admin is ${adminDeviceToken ?? ""}");
    }

    setState(() {});
  }

  List<JobModel> allJobs = [];
  List<JobModel> filteredJobs = [];
  String selectedStatus = "All";
  TextEditingController searchController = TextEditingController();
  bool isFilterDropdownVisible = false;

  @override
  void dispose() {
    animationController.dispose(); // Always dispose controllers
    super.dispose();
  }

  void applyFilters() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredJobs =
          allJobs.where((job) {
            final matchesText =
                job.jobTitle.toLowerCase().contains(query) ||
                job.companyName.toLowerCase().contains(query);
            final matchesStatus =
                selectedStatus == "All" ||
                job.applicationStatus == selectedStatus;
            return matchesText && matchesStatus;
          }).toList();

      // 🔽 Sort by applicationDate (latest first)
      filteredJobs.sort((a, b) {
        final dateA = DateTime.tryParse(a.applicationDate) ?? DateTime(2000);
        final dateB = DateTime.tryParse(b.applicationDate) ?? DateTime(2000);
        return dateB.compareTo(dateA); // Most recent first
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewJob()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child:
                            imageUrl != null && imageUrl!.isNotEmpty
                                ? Image.network(
                                  imageUrl!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/default_avatar.png',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                : Image.asset(
                                  'assets/images/default_avatar.png',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                      ),

                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? "",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email ?? "",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            phone ?? "",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Track Apply",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return dialogWidgetLogout(context);
                            },
                          );
                        },
                        child: Text(
                          "LOGOUT",
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextFieldWidget(
                          controller: searchController,
                          isPassword: false,
                          label: "Search by company name / job title",
                          onChanged: (val) => applyFilters(),
                        ),
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        width: 40,
                        child: Stack(
                          children: [
                            IconButton(
                              icon: Icon(Icons.filter_list),
                              onPressed: () {
                                setState(() {
                                  isFilterDropdownVisible =
                                      !isFilterDropdownVisible;
                                });
                              },
                            ),
                            if (isFilterDropdownVisible)
                              Positioned(
                                top: 35,
                                right: 0,
                                child: Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 160,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...[
                                          "All",
                                          "Applied",
                                          "Interview Scheduled",
                                          "On Hold",
                                          "Offered",
                                          "Rejected",
                                        ].map(
                                          (status) => InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedStatus = status;
                                                isFilterDropdownVisible =
                                                    false; // Hide dropdown
                                              });
                                              applyFilters(); // Apply filter
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12,
                                                  ),
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                  color:
                                                      selectedStatus == status
                                                          ? AppColors.primary
                                                          : Colors.black,
                                                  fontWeight:
                                                      selectedStatus == status
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection("jobs")
                              .where(
                                "userId",
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid,
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

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            allJobs =
                                snapshot.data!.docs
                                    .map((doc) => JobModel.fromMap(doc.data()))
                                    .toList();

                            applyFilters(); // ✅ Safe here
                          });
                        });

                        if (filteredJobs.isEmpty) {
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
                                  "No matching jobs found.",
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
                            itemCount: filteredJobs.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              final job = filteredJobs[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                JobDetailView(model: job),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center, // Important for wrapping
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Job Title: ${job.jobTitle}",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Company Name: ${job.companyName}",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  "Application Date: ${job.applicationDate}",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                job.applicationStatus ==
                                                        "Interview Scheduled"
                                                    ? RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "Interview Date: ",
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                job.interviewDate
                                                                    .toString(),
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                    : Container(),
                                                const SizedBox(height: 5),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (
                                                        BuildContext context,
                                                      ) {
                                                        return dialogWidget(
                                                          context,
                                                          job.id.toString(),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 100, // Fixed width
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "Delete",
                                                            softWrap: true,
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ), // some spacing between Expanded and status box
                                          // Fixed-size container for application status
                                          Container(
                                            width: 100, // Fixed width
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  job.applicationStatus ==
                                                          "Interview Scheduled"
                                                      ? Colors.green
                                                      : job.applicationStatus ==
                                                          "Rejected"
                                                      ? AppColors.error
                                                      : job.applicationStatus ==
                                                          "On Hold"
                                                      ? Colors.orangeAccent
                                                      : AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                job.applicationStatus,
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        height: 0.5,
                                        width: double.infinity,
                                        color: Colors.black,
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
                  const BannerAdWidget(),
                ],
              ),
            ),
            // 🔽 Dropdown Overlay (Only visible if icon tapped)
            if (isFilterDropdownVisible)
              Positioned(
                top: 110, // Adjust this depending on your layout
                right: 10,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...[
                          "All",
                          "Applied",
                          "Interview Scheduled",
                          "On Hold",
                          "Offered",
                          "Rejected",
                        ].map(
                          (status) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedStatus = status;
                                isFilterDropdownVisible = false;
                              });
                              applyFilters();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color:
                                      selectedStatus == status
                                          ? AppColors.primary
                                          : Colors.black,
                                  fontWeight:
                                      selectedStatus == status
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
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



  Widget dialogWidgetLogout(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Logout!",
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Are you sure want to logout?",
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
                      "NO",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                try {
                  logoutController.logoutUser(context);
                  // First close the dialog
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);

                  // Then show flushbar after popping dialog
                  Future.delayed(Duration(milliseconds: 100), () {
                    FlushBarMessages.successMessageFlushBar(
                      "User Logout successfully",
                      // ignore: use_build_context_synchronously
                      context,
                    );
                  });
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  Future.delayed(Duration(milliseconds: 100), () {
                    FlushBarMessages.errorMessageFlushBar(
                      "Error while logout the user: ${e.toString()}",
                      // ignore: use_build_context_synchronously
                      context,
                    );
                  });
                }

                Navigator.pop(context);
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
                      "YES",
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
}

Widget dialogWidget(BuildContext context, String jobId) {
  return AlertDialog(
    title: Text(
      "Delete Job",
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Text(
      "Are you sure want to delete this job?",
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
                    .collection("jobs")
                    .doc(jobId)
                    .delete();

                // First close the dialog
                // ignore: use_build_context_synchronously
                Navigator.pop(context);

                InterstitialAdHelper.showInterstitialAd();

                // Then show flushbar after popping dialog
                Future.delayed(Duration(milliseconds: 100), () {
                  FlushBarMessages.successMessageFlushBar(
                    "Job deleted successfully",
                    // ignore: use_build_context_synchronously
                    context,
                  );
                });
              } catch (e) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                Future.delayed(Duration(milliseconds: 100), () {
                  FlushBarMessages.errorMessageFlushBar(
                    "Error while deleting the job: ${e.toString()}",
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
