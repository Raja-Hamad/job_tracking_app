import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_tracking_app/models/resumes_model.dart';
import 'package:job_tracking_app/services/firestore_services.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';
import 'package:dio/dio.dart';
import 'package:job_tracking_app/widgets/interstitial_ad_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ResumeController extends GetxController {
  final FirestoreServices _firestoreServices = FirestoreServices();
  Future<void> uploadResumeToFirebase(
    ResumesModel model,
    BuildContext context,
  ) async {
    try {
      await _firestoreServices.uploadResumeToFirebase(model, context);
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

  Future<void> downloadPdf(
    String pdfUrl,
    String fileName,
    BuildContext context,
  ) async {
    try {
      // Ask for permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission is required.")),
        );
        return;
      }

      final Directory directory;
      if (Platform.isAndroid) {
        directory = Directory(
          '/storage/emulated/0/Download',
        ); // 📂 Downloads folder
      } else {
        directory = await getApplicationDocumentsDirectory(); // iOS fallback
      }

      final filePath = '${directory.path}/$fileName.pdf';

      Dio dio = Dio();
      await dio.download(
        pdfUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint(
              "Downloading: ${(received / total * 100).toStringAsFixed(0)}%",
            );
          }
        },
      );
      InterstitialAdHelper.showInterstitialAd();

      FlushBarMessages.successMessageFlushBar(
        "Downloaded to $filePath",
        // ignore: use_build_context_synchronously
        context,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      FlushBarMessages.errorMessageFlushBar(
        "Download failed: ${e.toString()}",
        // ignore: use_build_context_synchronously
        context,
      );
      if (kDebugMode) {
        print("Error while downloading the resume is ${e.toString()}");
      }
    }
  }
}
