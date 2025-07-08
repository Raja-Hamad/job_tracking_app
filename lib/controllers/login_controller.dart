import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/views/add_interview_questions.dart';
import 'package:job_tracking_app/views/bottom_nav_bar_view.dart';
import '../services/auth_services.dart';

class LoginController extends GetxController {
  final AuthServices _authServices = AuthServices();
  List<String> adminEmails = [
    "admin1@gmail.com",
    "admin2@gmail.com",
    "admin3@gmail.com",
    "admin4@gmail.com",
  ];

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

    if (email.isEmpty || password.isEmpty) {
      FlushBarMessages.errorMessageFlushBar(
        "Email and password are required.",
        context,
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      FlushBarMessages.errorMessageFlushBar(
        "Please enter a valid email address.",
        context,
      );
      return;
    }

    isLoading.value = true;

    // ✅ Check if admin login
    if (adminEmails.contains(email)) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // ignore: use_build_context_synchronously
        FlushBarMessages.successMessageFlushBar("Admin logged in", context);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder:
                (_) =>
                    const AddInterviewQuestions(), // replace with your admin screen
          ),
        );
      } catch (e) {
        FlushBarMessages.errorMessageFlushBar(
          "Admin login failed: ${e.toString()}",
          // ignore: use_build_context_synchronously
          context,
        );
        if (kDebugMode) {
          print("Admin Login failed ${e.toString()}");
        }
      } finally {
        isLoading.value = false;
      }
      return;
    }

    // 🧑 Regular user login
    final error = await _authServices.loginUser(email, password);
    isLoading.value = false;

    if (error == null) {
      // ignore: use_build_context_synchronously
      FlushBarMessages.successMessageFlushBar("Login Successfully", context);
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    } else {
      errorMessage.value = error;

      final isInvalidLogin =
          error.toLowerCase().contains("password is invalid") ||
          error.toLowerCase().contains("no user record");

      FlushBarMessages.errorMessageFlushBar(
        isInvalidLogin
            ? "Invalid email or password. Please try again."
            : error.toString(),
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }
}
