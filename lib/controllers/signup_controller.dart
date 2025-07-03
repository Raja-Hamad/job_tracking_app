import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_tracking_app/services/firestore_services.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/views/login_view.dart';
import '../services/auth_services.dart';
import 'package:intl/intl.dart';

class SignupController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final FirestoreServices _firestoreServices = FirestoreServices();
  var isLoading = false.obs;
  RxString errorMessage = ''.obs;
  var phoneController = TextEditingController().obs;
  var addressController = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var selectedGender = "".obs;
  var selectedDob = "".obs;
  var profileImagePath = "".obs;
  void disposeValues() {
    addressController.value.clear();
    phoneController.value.clear();
    nameController.value.clear();
    emailController.value.clear();
    passwordController.value.clear();
    selectedGender.value = '';
    selectedDob.value = '';
    profileImagePath.value = '';
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDob.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  var selectedImage = Rxn<File>();

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<void> registerAdmin({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String dob,
    required String address,
    required File? image,
    required BuildContext context,
  }) async {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$',
    );
    // 🔒 Validation rules
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    // 🔐 Password strength check
    if (!passwordRegex.hasMatch(password)) {
      FlushBarMessages.errorMessageFlushBar(
        "Password must be at least 8 characters and include a letter, number, and special character.",
        context,
      );
      return;
    }
    // 📧 Email format check
    if (!emailRegex.hasMatch(email)) {
      FlushBarMessages.errorMessageFlushBar(
        "Please enter a valid email address.",
        context,
      );
      return;
    }

    if (password.isEmpty ||
        email.isEmpty ||
        name.isEmpty ||
        dob.isEmpty ||
        image == null ||
        gender.isEmpty ||
        address.isEmpty ||
        phone.isEmpty) {
      FlushBarMessages.errorMessageFlushBar(
        "Please fill all the fields",
        context,
      );
      return;
    }

    isLoading.value = true;
    // Upload the image to Cloudinary
    String? imageUrl;
    if (image != null) {
      imageUrl = await _firestoreServices.uploadImageToCloudinary(
        image,
        context,
      );
    }
    final error = await _authServices.registerAdmin(
      name,
      email,
      password,
      phone,
      address,
      imageUrl ?? "",
      dob,
      gender,
    );
    isLoading.value = false;

    if (error == null) {
      FlushBarMessages.successMessageFlushBar(
        "Registered Successfully",
        // ignore: use_build_context_synchronously
        context,
      );
      disposeValues();
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      // ignore: use_build_context_synchronously
    } else {
      // ignore: use_build_context_synchronously
      FlushBarMessages.errorMessageFlushBar(error.toString(), context);
      errorMessage.value = error;
    }
  }
}
