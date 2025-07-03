import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:job_tracking_app/models/job_model.dart';
import 'package:job_tracking_app/services/firestore_services.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/views/dashboard_view.dart';
import 'package:job_tracking_app/widgets/interstitial_ad_widget.dart';

class UpdateJobDetailsController extends GetxController {
  final FirestoreServices _firestoreServices = FirestoreServices();
  var applicationStatus = ''.obs;
  var jobTitleController = TextEditingController().obs;
  var notesController = TextEditingController().obs;
  var companyNameController = TextEditingController().obs;
  var interviewDate = ''.obs;
  var applicationDate = ''.obs;
  var isLoading = false.obs;
  Future<void> pickDate(BuildContext context, RxString date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      date.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> updateJobDetails(JobModel model, BuildContext context) async {
    try {
      if (model.applicationDate.isEmpty ||
          model.applicationStatus.isEmpty ||
          model.jobTitle.isEmpty ||
          model.companyName.isEmpty ||
          model.interviewDate.isEmpty ||
          model.notes.isEmpty) {
        FlushBarMessages.errorMessageFlushBar(
          "Please fill all field to proceed",
          context,
        );
        return;
      }
      if (kDebugMode) {}
      await _firestoreServices.updateJobDetails(model, context);
      // ignore: use_build_context_synchronously
      FlushBarMessages.successMessageFlushBar(
        "Job details updated successfully",
        // ignore: use_build_context_synchronously
        context,
      );
      // ignore: use_build_context_synchronously
      Get.offAll(() => DashboardView()); // removes all previous screens
      InterstitialAdHelper.showInterstitialAd();
    } catch (e) {
      if (kDebugMode) {
        print("Error while updating the job details ${e.toString()}");
      }
      FlushBarMessages.errorMessageFlushBar(
        "Error while updating the job details is ${e.toString()}",
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }
}
