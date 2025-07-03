import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/job_controller.dart';
import 'package:job_tracking_app/models/job_model.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/utils/extensions/local_storage.dart';
import 'package:job_tracking_app/widgets/multiline_text_field_widget.dart';
import 'package:job_tracking_app/widgets/submit_button_widget.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';
import 'package:uuid/uuid.dart';

class AddNewJob extends StatefulWidget {
  const AddNewJob({super.key});

  @override
  State<AddNewJob> createState() => _AddNewJobState();
}

class _AddNewJobState extends State<AddNewJob> {
  JobController jobController = Get.put(JobController());
  LocalStorage localStorage = LocalStorage();
  String? name;
  String? email;
  String? role;
  String? userDeviceToken;

  String? imageUrl;
  getValues() async {
    name = await localStorage.getValue("userName");
    email = await localStorage.getValue("email");
    role = await localStorage.getValue("role");
    imageUrl = await localStorage.getValue("imageUrl");
    userDeviceToken = await localStorage.getValue("userDeviceToken");
    if (kDebugMode) {
      print("Device Token of the admin is ${userDeviceToken ?? ""}");
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Job',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextFieldWidget(
                  controller: jobController.jobTitleController.value,
                  isPassword: false,
                  label: "Enter Job Title",
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller: jobController.companyNameController.value,
                  isPassword: false,
                  label: "Enter Company Name",
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
                          jobController
                                  .selectedJobApplicationStatus
                                  .value
                                  .isNotEmpty
                              ? jobController.selectedJobApplicationStatus.value
                              : null,
                      decoration: InputDecoration(
                        labelText: "Application Status",
                        labelStyle: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                      ),
                      items:
                          [
                            "Applied",
                            "Interview Scheduled",
                            "On Hold",
                            "Offered",
                            "Rejected",
                          ].map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender, style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                      onChanged: (value) {
                        jobController.selectedJobApplicationStatus.value =
                            value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => GestureDetector(
                    onTap: () => jobController.pickDate(context),
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
                            jobController.applicationDate.value.isEmpty
                                ? "Application Date"
                                : jobController.applicationDate.value,
                            style: GoogleFonts.poppins(
                              color:
                                  jobController.applicationDate.value.isEmpty
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
                const SizedBox(height: 16),
                MultilineTextFieldWidget(
                  controller: jobController.notesController.value,
                  label: "Notes(Optional)",
                ),
                const SizedBox(height: 40),
                SubmitButtonWidget(
                  isLoading: jobController.isLoading.value,
                  buttonColor: AppColors.primary,
                  title: "Add Job",
                  onPress: () {
                    FocusScope.of(context).unfocus();
                    String userId = FirebaseAuth.instance.currentUser!.uid;
                    String id = Uuid().v4();
                    String jobTitle =
                        jobController.jobTitleController.value.text.trim();
                    String companyName =
                        jobController.companyNameController.value.text.trim();
                    String applicationDate =
                        jobController.applicationDate.value.trim();
                    String applicationStatus =
                        jobController.selectedJobApplicationStatus.value.trim();
                    String notes =
                        jobController.notesController.value.text.trim();
                    String interviewDate = "Not Scheduled";
                    String deviceToken = userDeviceToken ?? "";
                    JobModel jobModel = JobModel(
                      applicationDate: applicationDate,
                      applicationStatus: applicationStatus,
                      companyName: companyName,
                      id: id,
                      interviewDate: interviewDate,
                      jobTitle: jobTitle,
                      notes: notes,
                      userDeviceToken: deviceToken,
                      userId: userId,
                    );
                    final createdAt = jobModel.toMap();
                    createdAt['createdAt'] =
                        FieldValue.serverTimestamp(); // Add timestamp manually

                    jobController.addNewJob(jobModel, context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
