import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class ResumeBuilderController extends GetxController {
  var nameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;

  var phoneController = TextEditingController().obs;

  var addressController = TextEditingController().obs;
  var degreeController = TextEditingController().obs;
  var instituteController = TextEditingController().obs;

  var startController = TextEditingController().obs;

  var endController = TextEditingController().obs;
  RxString selectedGender = ''.obs;
  RxString dob = ''.obs;
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dob.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}
