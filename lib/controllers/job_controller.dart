import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:job_tracking_app/models/job_model.dart';
import 'package:job_tracking_app/services/firestore_services.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';

class JobController extends GetxController {
  var isLoading = false.obs;
  final FirestoreServices _firestoreServices = FirestoreServices();
  var jobTitleController = TextEditingController().obs;
  var companyNameController = TextEditingController().obs;
  var applicationDate = ''.obs;
  var notesController = TextEditingController().obs;

  var selectedJobApplicationStatus = ''.obs;

  void disposeValues() {
    jobTitleController.value.clear();
    companyNameController.value.clear();
    notesController.value.clear();
    applicationDate.value = '';
    selectedJobApplicationStatus.value = '';
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      applicationDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> addNewJob(JobModel model, BuildContext context) async {
    try {
      if (jobTitleController.value.text.isEmpty ||
          companyNameController.value.text.isEmpty ||
          selectedJobApplicationStatus.value.isEmpty ||
          notesController.value.text.isEmpty ||
          applicationDate.value.isEmpty) {
        FlushBarMessages.errorMessageFlushBar(
          "Please fill all fields to add job",
          context,
        );
        return;
      }
      isLoading.value = true;
      await _firestoreServices.addNewJob(model, context);
      FlushBarMessages.successMessageFlushBar(
        "New job added successfully",
        // ignore: use_build_context_synchronously
        context,
      );
      disposeValues();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      FlushBarMessages.errorMessageFlushBar(
        "Error while adding the job is ${e.toString()}",
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }
}
