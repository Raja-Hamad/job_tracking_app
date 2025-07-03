import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:job_tracking_app/services/firestore_services.dart';
import 'package:job_tracking_app/views/login_view.dart';

class UpdateProfileController extends GetxController {
  var textEditingControllerEmail = TextEditingController().obs;
  var textEditingControllerName = TextEditingController().obs;
  var textEditingControllerPhone = TextEditingController().obs;
  var textEditingControllerAddress = TextEditingController().obs;
  final FirestoreServices _firestoreServices = FirestoreServices();
  RxString dob = ''.obs;
  RxString gender = ''.obs;
  var isLoading = false.obs;
  var selectedImage = Rxn<File>();

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<void> updateProfile(
    String newEmail,
    String newName,
    String dob,
    String gender,
    String phone,
    String address,
    File? imageFile,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;

      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        Get.snackbar("Error", "User not logged in.");
        return;
      }

      // Re-authenticate the user if needed (this depends on your app flow)

      // 🔄 Step 1: Update email in Firebase Authentication
      if (currentUser.email != newEmail) {
        await currentUser.verifyBeforeUpdateEmail(newEmail);
      }
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _firestoreServices.uploadImageToCloudinary(
          imageFile,
          // ignore: use_build_context_synchronously
          context,
        );
      }

      // ✅ Step 2: Update Firestore user info
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
            'email': newEmail,
            'userName': newName,
            'dob': dob,
            'gender': gender,
            'address': address,
            'phone': phone,
            'imageUrl': imageUrl,
          });

      // ✅ Step 3: Remove from local storage (already done by you)
      // ✅ Step 4: Navigate to login screen
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
