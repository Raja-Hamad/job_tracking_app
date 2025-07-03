import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/job_controller.dart';
import 'package:job_tracking_app/controllers/update_job_details_controller.dart';
import 'package:job_tracking_app/models/job_model.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/utils/extensions/local_storage.dart';
import 'package:job_tracking_app/widgets/multiline_text_field_widget.dart';
import 'package:job_tracking_app/widgets/submit_button_widget.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
// ignore: library_prefixes

// ignore: must_be_immutable
class EditJobDetailsView extends StatefulWidget {
  JobModel jobModel;
  EditJobDetailsView({super.key, required this.jobModel});

  @override
  State<EditJobDetailsView> createState() => _EditJobDetailsViewState();
}

class _EditJobDetailsViewState extends State<EditJobDetailsView> {
  JobController jobController = Get.put(JobController());
  UpdateJobDetailsController updateJobDetailsController = Get.put(
    UpdateJobDetailsController(),
  );
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

    // ✅ Only call setState if the widget is still mounted
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    updateJobDetailsController.applicationDate.value =
        widget.jobModel.applicationDate;
    updateJobDetailsController.interviewDate.value = "Interview Date";
    updateJobDetailsController.jobTitleController.value.text =
        widget.jobModel.jobTitle;
    updateJobDetailsController.notesController.value.text =
        widget.jobModel.notes;
    updateJobDetailsController.companyNameController.value.text =
        widget.jobModel.companyName;
    updateJobDetailsController.applicationStatus.value =
        widget.jobModel.applicationStatus;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getValues();
    });
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
                  'Edit Job',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Job Title",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller:
                      updateJobDetailsController.jobTitleController.value,
                  isPassword: false,
                  label: "Enter Job Title",
                ),
                const SizedBox(height: 16),
                Text(
                  "Company Name",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller:
                      updateJobDetailsController.companyNameController.value,
                  isPassword: false,
                  label: "Enter Company Name",
                ),
                const SizedBox(height: 16),
                Text(
                  "Application Status",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
                          updateJobDetailsController
                                  .applicationStatus
                                  .value
                                  .isEmpty
                              ? "Application Status"
                              : updateJobDetailsController
                                  .applicationStatus
                                  .value,
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
                        updateJobDetailsController.applicationStatus.value =
                            value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Application Date",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => GestureDetector(
                    onTap:
                        () => updateJobDetailsController.pickDate(
                          context,
                          updateJobDetailsController.applicationDate,
                        ),
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
                            updateJobDetailsController
                                    .applicationDate
                                    .value
                                    .isEmpty
                                ? "Application Date"
                                : updateJobDetailsController
                                    .applicationDate
                                    .value,

                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
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
                Text(
                  "Interview Date",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => GestureDetector(
                    onTap:
                        () => updateJobDetailsController.pickDate(
                          context,
                          updateJobDetailsController.interviewDate,
                        ),
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
                            updateJobDetailsController
                                    .interviewDate
                                    .value
                                    .isEmpty
                                ? "Interview Date"
                                : updateJobDetailsController
                                    .interviewDate
                                    .value,

                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
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
                Text(
                  "Notes",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                MultilineTextFieldWidget(
                  controller: updateJobDetailsController.notesController.value,
                  label: "Notes(Optional)",
                ),
                const SizedBox(height: 40),
                SubmitButtonWidget(
                  isLoading: updateJobDetailsController.isLoading.value,
                  buttonColor: AppColors.primary,
                  title: "Edit Job",
                  onPress: () async {
                    String userId = FirebaseAuth.instance.currentUser!.uid;
                    String id = widget.jobModel.id;
                    String jobTitle =
                        updateJobDetailsController
                                .jobTitleController
                                .value
                                .text
                                .isEmpty
                            ? widget.jobModel.jobTitle
                            : updateJobDetailsController
                                .jobTitleController
                                .value
                                .text
                                .trim()
                                .toString();
                    String companyName =
                        updateJobDetailsController
                                .companyNameController
                                .value
                                .text
                                .isEmpty
                            ? widget.jobModel.companyName
                            : updateJobDetailsController
                                .companyNameController
                                .value
                                .text
                                .trim()
                                .toString();
                    String applicationDate =
                        updateJobDetailsController.applicationDate.value.isEmpty
                            ? widget.jobModel.applicationDate
                            : updateJobDetailsController.applicationDate.value
                                .trim()
                                .toString();
                    String applicationStatus =
                        updateJobDetailsController
                                .applicationStatus
                                .value
                                .isEmpty
                            ? widget.jobModel.applicationStatus
                            : updateJobDetailsController.applicationStatus.value
                                .trim()
                                .toString();
                    String notes =
                        updateJobDetailsController
                                .notesController
                                .value
                                .text
                                .isEmpty
                            ? widget.jobModel.notes
                            : updateJobDetailsController
                                .notesController
                                .value
                                .text
                                .trim()
                                .toString();
                    String interviewDate =
                        updateJobDetailsController.interviewDate.value.isEmpty
                            ? widget.jobModel.interviewDate
                            : updateJobDetailsController.interviewDate.value
                                .trim()
                                .toString();
                    String deviceToken = widget.jobModel.userDeviceToken;
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

                    if (applicationStatus == "Interview Scheduled" &&
                        (interviewDate.isEmpty ||
                            interviewDate == "Interview Date")) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return dialogWidget(context);
                        },
                      );
                    } else {
                      updateJobDetailsController.updateJobDetails(
                        jobModel,
                        context,
                      );
                      if (applicationStatus == "Interview Scheduled" &&
                          interviewDate.isNotEmpty) {
                        DateTime interviewDateTime = DateTime.parse(
                          interviewDate,
                        );

                        // Schedule for one day before at 12:00 PM
                        // DateTime scheduledDateTime = DateTime(
                        //   interviewDateTime.year,
                        //   interviewDateTime.month,
                        //   interviewDateTime.day - 1,
                        //   12, // 12 PM
                        //   0,
                        // );

                      await  submitNotification(
                          userDeviceToken ?? "",
                          jobTitle,
                          "Your interview has been scheduled in $companyName at $interviewDate",
                          interviewDate,
                          id,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "job-tracking-app-d38b2",
      "private_key_id": "f42a17848fb8b531448fb063bee0d0bea765865a",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCbwUn2fAidLS3F\n1jxLshDTEd75M2d5/5GltcJYND3fQIy5HjhLFbR9WNOJOsnNGXEJYkTsD5/1a3VM\nKDlZx88+6ZtpwCarXT7a+iSXtjOzyhG3ib5lCLGIkUH8rZdFZZ1syncpvu9NkYob\neB2+nJYQiQdrWKkisM33E0n4NrgwSsm14IHXZ1AI9YA1I8Ctk+YIpZrEf03EuDUl\nil254INqM/36YYOJX/owpe39dUSvSnR424cbGxUDbP3ynyyjlHT8RdVulVxGzB/8\nc5jfRDx0w66Xaalg9dGstx9Oan0KhYCAVUxn3snuWDjEHJcGapuLvTs3YuTFMlRk\nG1IVDNCRAgMBAAECggEAEqmHv7Ff5NlPdTd0tQsqaefnxAstOFhvbqAHH8NusGvP\nELU2wIRiwmwcuIIjQOBuA1ZTdMdwfpr4DH57VK8UvXCHLxYXbAv5poo3TThHHKE3\nGzs1ZWyzvO3OrsRr7iQ9RxZBTe6zRKOOHTl4suiXMHcCvRF7/oyZuSOGBugjjKGR\nU7FOSZumq+H7nampfTyXxcAoGYmj+ufuPDPdUiqSAXSdwz7DVbeXCSt8frKWPQL8\nao/XcPI8wFZ/pFDZZRx05YuGUWAAGY79TvbzFzSuHHjpfsaARPb7LdaaFkEx8xnw\npvK6dX37ydbs79hkVW/2jz7POFxvS4BHvg3MkZNyywKBgQDb4H3jnrEwP65tnJaS\ndYSU7+vmS4WquoAO+zuNLPsOBqH5pZD+eu2Ur5z4H/2XmoNExpWFgaqVJwYnhhKf\n2NrTOc2O4LJqSRsqX0LrjVCzFxfM3nGPQZ1tYDPMPUVRuUb3cSgaKPCPILBu1/dT\nFQrGhFOZs7pCnyND7LN7gfQMGwKBgQC1V/sYDfkxGKf+5m0pTK1mLaQtRQBNn6IM\nka7CRSUXGxPxAN2r8z5juAQY9ETvQhYVUg8rzvLEVkn8fejN3W07IaKMINNUhpzl\n1isd4vfpPZ+woq+55sY0L4FSa2y40Ay+yh1z9mD1xrytUo0YET+fVANcySBnmWYm\ncek2KkBIwwKBgQC3WP6A5R6JxkB0ZKPmYxp4e4wxkH5YvIX2eCbTdVOwAXXlz9sV\naXpdhwcUnNCBL7YQjqu2FUcictUd9h3nrxPiGQxA/Tuph2agsakC9Ob7P+F303HM\nbIGS6CqpP9pi6GW2BmTTU5otL6wP8gTqAdznZwazX3yM+1iT1nhgICBaSwKBgC1c\n5tjrlexsKIohBimQnseynyEb46mHRzgxsS+zsEWJZoGhH9KFtJOpUo0TfbMEKxYG\nQvlIeX4Xv8ZDkNr+ivaBwXGgPH0md1UfMAX34uAbpDjBWYf9bJNdVtJRQQ8yLB4F\n3TxG45ZXspcA0X61wd6PW4/4V/zSaLUxRY9hHleVAoGBAMCqExSXx5AxQu3zrgXZ\n7e71/xYEN7QTamC3IoaOdvVdddeutZqeXw5Uaf1CMi99HJmjm6xYuWrzqOzMwxwg\n2LE2F0CXwJH00kN7x7M6HXkIj8oAeswi52Oi0jX6ySco0RGppOE493dv4xxQXjg4\nRyQl/QBEoBQLaJOwJX3LOO/f\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@job-tracking-app-d38b2.iam.gserviceaccount.com",
      "client_id": "115953967306343707586",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40job-tracking-app-d38b2.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials = await auth
        .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client,
        );

    client.close();
    return credentials.accessToken.data;
  }

  Future<void> sendNotificationToClients(
    String notificationBody,
    String notificationTitle,
    String devicesToken,
    String interviewDate,
    String jobId,
  ) async {
    final String serverKey = await getAccessToken();

    var notificationData = {
      'message': {
        'token': devicesToken,
        'notification': {'title': notificationTitle, 'body': notificationBody},
        'data': {'interviewDate': interviewDate, 'jobId': jobId},
      },
    };

    var response = await http.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/job-tracking-app-d38b2/messages:send',
      ), // Update YOUR_PROJECT_ID
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $serverKey', // Replace with actual access token
      },
      body: jsonEncode(notificationData),
    );

    // Check response for errors
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Notification sent successfully');
      }
    } else {
      if (kDebugMode) {
        print(
          'Error sending notification: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
    }
  }

  submitNotification(
    String userDeviceToken,
    String notificationTitle,
    String notificationBody,
    String interviewDate,
    String jobId,
  ) async {
    try {
      if (kDebugMode) {
        print("Device Token of the user is $userDeviceToken");
        print("Notification Title of the user is $notificationTitle");
        print("Notification Body of the user is $notificationBody");
      }
      if (notificationTitle.isNotEmpty && notificationBody.isNotEmpty) {
        await sendNotificationToClients(
          notificationBody,
          notificationTitle,
          userDeviceToken,
          interviewDate,
          jobId,
        );
      } else {
        if (kDebugMode) {
          print("Please fill in all fields.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while generating the notification ${e.toString()}");
      }
    }
  }
}

Widget dialogWidget(BuildContext context) {
  return AlertDialog(
    title: Text(
      "Select Interview Date",
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Text(
      "You selected interview scheduled. Now you should have to select the interview date.",
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    actions: [
      InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
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
  );
}
