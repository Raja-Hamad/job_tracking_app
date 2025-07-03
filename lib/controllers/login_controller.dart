import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/views/bottom_nav_bar_view.dart';
import 'package:job_tracking_app/views/dashboard_view.dart';
import '../services/auth_services.dart';

class LoginController extends GetxController {
  final AuthServices _authServices = AuthServices();

  var isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> loginAdmin({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  email = email.trim();
  password = password.trim();

  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  // Empty field check
  if (email.isEmpty || password.isEmpty) {
    FlushBarMessages.errorMessageFlushBar(
      "Email and password are required.",
      context,
    );
    return;
  }

  // Email format check
  if (!emailRegex.hasMatch(email)) {
    FlushBarMessages.errorMessageFlushBar(
      "Please enter a valid email address.",
      context,
    );
    return;
  }

  isLoading.value = true;
  final error = await _authServices.loginUser(email, password);
  isLoading.value = false;

  if (error == null) {
    // ignore: use_build_context_synchronously
    FlushBarMessages.successMessageFlushBar("Login Successfully", context);
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const BottomNavBar ()),
    );
  } else {
    errorMessage.value = error;

    // Show friendly message for incorrect credentials
    final isInvalidLogin = error.toLowerCase().contains("password is invalid") ||
                           error.toLowerCase().contains("no user record");

    if (isInvalidLogin) {
      FlushBarMessages.errorMessageFlushBar(
        "Invalid email or password. Please try again.",
        // ignore: use_build_context_synchronously
        context,
      );
    } else {
      FlushBarMessages.errorMessageFlushBar(
        error.toString(),
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }
}

}
