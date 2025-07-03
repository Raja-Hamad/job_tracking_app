import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:job_tracking_app/controllers/resume_controller.dart';
import 'package:job_tracking_app/models/resumes_model.dart';
import 'package:job_tracking_app/services/firestore_services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

ResumeController controller = Get.put(ResumeController());
final FirestoreServices _firestoreServices = FirestoreServices();

class GenerateResumePdf {
  static Future<void> generateResumePdf({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String gender,
    required String dob,
    required String objective,
    required List<Map<String, TextEditingController>> educationList,
    required List<Map<String, TextEditingController>> experienceList,
    required List<String> skills,
    required List<String> projects,
    required List<String> languages,
    required List<String> certifications,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build:
            (context) => [
              pw.Text(
                name,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "Email: $email | Phone: $phone",
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                "Address: $address | Gender: $gender | DOB: $dob",
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                "Professional Summary",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              pw.Bullet(text: objective),
              pw.SizedBox(height: 12),

              if (experienceList.isNotEmpty) ...[
                pw.Text(
                  "Work Experience",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ...experienceList.map((exp) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "${exp['position']?.text ?? ""} at ${exp['company']?.text ?? ""} (${exp['startYear']?.text} - ${exp['endYear']?.text})",
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                    ],
                  );
                }),
                pw.SizedBox(height: 12),
              ],

              if (educationList.isNotEmpty) ...[
                pw.Text(
                  "Education",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ...educationList.map((edu) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "${edu['degree']?.text ?? ""}, ${edu['institute']?.text ?? ""} (${edu['startYear']?.text} - ${edu['endYear']?.text})",
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }),
                pw.SizedBox(height: 12),
              ],

              if (skills.isNotEmpty) ...[
                pw.Text(
                  "Skills",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                pw.Wrap(
                  spacing: 6,
                  children: skills.map((skill) => pw.Text("• $skill")).toList(),
                ),
                pw.SizedBox(height: 12),
              ],

              if (projects.isNotEmpty) ...[
                pw.Text(
                  "Projects",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ...projects.map((proj) => pw.Bullet(text: proj)),
                pw.SizedBox(height: 12),
              ],

              if (certifications.isNotEmpty) ...[
                pw.Text(
                  "Certifications",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ...certifications.map((cert) => pw.Bullet(text: cert)),
                pw.SizedBox(height: 12),
              ],

              if (languages.isNotEmpty) ...[
                pw.Text(
                  "Languages",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ...languages.map((lang) => pw.Bullet(text: lang)),
              ],
            ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

class GenerateResumePdf1 {
  static Future<void> saveAndOpenPdf(
    pw.Document pdfDoc,
    String fileName,
    BuildContext context,
  ) async {
    // Show dialog for file name input
    final TextEditingController fileNameController = TextEditingController(
      text: fileName.replaceAll('.pdf', ''),
    );

    final newFileName = await showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text("Enter Resume File Name"),
            content: TextField(
              controller: fileNameController,
              decoration: const InputDecoration(
                labelText: "File Name",
                hintText: "e.g. MyResume2025",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx), // Cancel
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final input = fileNameController.text.trim();
                  if (input.isNotEmpty) {
                    Navigator.pop(ctx, input);
                  }
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );

    // If user cancels or doesn't enter anything, abort
    if (newFileName == null || newFileName.isEmpty) return;

    final adjustedFileName = "$newFileName.pdf";

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$adjustedFileName");
    await file.writeAsBytes(await pdfDoc.save());

    // Upload to Cloudinary
    final downloadUrl = await _firestoreServices.uploadPdfToCloudinary(
      file,
      // ignore: use_build_context_synchronously
      context,
    );

    // Save metadata to Firestore
    final userId = FirebaseAuth.instance.currentUser!.uid;
    ResumesModel resumeModel = ResumesModel(
      downloadUrl: downloadUrl,
      fileName: adjustedFileName,
      id: const Uuid().v4(),
      userId: userId,
    );

    final createdAt = resumeModel.toMap();
    createdAt['timestamp'] = FieldValue.serverTimestamp();

    // ignore: use_build_context_synchronously
    await controller.uploadResumeToFirebase(resumeModel, context);

    // Open the file
    await OpenFile.open(file.path);
  }
}
