import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_tracking_app/models/interview_questions.dart';
import 'package:job_tracking_app/models/job_model.dart';
import 'package:job_tracking_app/models/resumes_model.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:job_tracking_app/views/dashboard_view.dart';
import 'package:job_tracking_app/widgets/interstitial_ad_widget.dart';

class FirestoreServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<String> uploadImageToCloudinary(
    File imageFile,
    BuildContext context,
  ) async {
    final cloudName = 'dqs1y6urv'; // Replace with your Cloudinary Cloud Name
    final apiKey = '463369248646777'; // Replace with your Cloudinary API Key
    final preset =
        'ecommerce_preset'; // Replace with your Cloudinary Upload Preset

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = preset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();
    if (response.statusCode == 200) {
      FlushBarMessages.successMessageFlushBar(
        "Image Uploaded Successfully",
        // ignore: use_build_context_synchronously
        context,
      );
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);
      return data['secure_url']; // Image URL from Cloudinary
    } else {
      // ignore: use_build_context_synchronously
      FlushBarMessages.errorMessageFlushBar("Failed to upload Image", context);
      throw Exception('Failed to upload image to Cloudinary');
    }
  }

  Future<void> addNewJob(JobModel model, BuildContext context) async {
    try {
      await _firebaseFirestore
          .collection("jobs")
          .doc(model.id)
          .set(model.toMap());
      // ignore: use_build_context_synchronously
      FlushBarMessages.successMessageFlushBar(
        "New job added successfully",
        // ignore: use_build_context_synchronously
        context,
      );
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => DashboardView()),
      );
      InterstitialAdHelper.showInterstitialAd();
    } catch (error) {
      // ignore: use_build_context_synchronously
      FlushBarMessages.errorMessageFlushBar(
        "Error while adding the new job ${error.toString()}",
        // ignore: use_build_context_synchronously
        context,
      );
      if (kDebugMode) {
        print("Error while adding the new job is ${error.toString()}");
      }
    }
  }

  Future<void> updateJobDetails(JobModel model, BuildContext context) async {
    try {
      await _firebaseFirestore
          .collection("jobs")
          .doc(model.id)
          .update(model.toMap());
      FlushBarMessages.successMessageFlushBar(
        "Job data updated successfullly",
        // ignore: use_build_context_synchronously
        context,
      );
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

  Future<void> uploadResumeToFirebase(
    ResumesModel model,
    BuildContext context,
  ) async {
    try {
      await _firebaseFirestore
          .collection("resumes")
          .doc(model.id)
          .set(model.toMap());
      FlushBarMessages.successMessageFlushBar(
        "Successfully uploaded the resume",
        // ignore: use_build_context_synchronously
        context,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error while uploading the resume is ${e.toString()}");
      }
      FlushBarMessages.successMessageFlushBar(
        "Error while uploading the resume is ${e.toString()}",
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }

  Future<String> uploadPdfToCloudinary(
    File pdfFile,
    BuildContext context,
  ) async {
    final cloudName = 'dqs1y6urv';
    final apiKey = '463369248646777';
    final preset = 'ecommerce_preset';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/raw/upload', // use `raw` for PDFs
    );

    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = preset
          ..files.add(await http.MultipartFile.fromPath('file', pdfFile.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final data = jsonDecode(res.body);
      FlushBarMessages.successMessageFlushBar(
        "Resume uploaded successfully",
        // ignore: use_build_context_synchronously
        context,
      );
      return data['secure_url'];
    } else {
      FlushBarMessages.errorMessageFlushBar(
        "Failed to upload Resume PDF",
        // ignore: use_build_context_synchronously
        context,
      );
      throw Exception('Failed to upload resume PDF to Cloudinary');
    }
  }

  Future<void> addInterviewQuestion(
    InterviewQuestion model,
    BuildContext context,
  ) async {
    try {
      await _firebaseFirestore
          .collection("interview_questions")
          .doc(model.id)
          .set(model.toMap());
      FlushBarMessages.successMessageFlushBar(
        "Interview Question added successfully",
        // ignore: use_build_context_synchronously
        context,
      );
    } catch (e) {
      FlushBarMessages.errorMessageFlushBar(
        "Error while uploading the question is ${e.toString()}",
        // ignore: use_build_context_synchronously
        context,
      );
      if (kDebugMode) {
        print("Error while uploading the question is ${e.toString()}");
      }
    }
  }
}
