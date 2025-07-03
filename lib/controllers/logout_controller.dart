import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:job_tracking_app/services/auth_services.dart';
import 'package:job_tracking_app/utils/extensions/local_storage.dart';
import 'package:job_tracking_app/views/login_view.dart';

class LogoutController extends GetxController {
  AuthServices authServices = AuthServices();
  LocalStorage localStorage = LocalStorage();
  var isLoggingOut = false.obs;

  Future<void> logoutUser(BuildContext context) async {
    try {
      isLoggingOut.value = true;

      // Firebase Sign Out
      await authServices.logout();
      isLoggingOut.value = false;
      await localStorage.clear("userName");
      await localStorage.clear("email");
      await localStorage.clear("userDeviceToken");
      await localStorage.clear("id");
      await localStorage.clear("dob");
      await localStorage.clear("gender");
      await localStorage.clear("address");
      await localStorage.clear("phone");
      await localStorage.clear("imageUrl");

      // Clear Shared Preferences / Local Storage

      // Navigate to login screen
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    } finally {
      isLoggingOut.value = false;
    }
  }
}
