import 'package:flutter/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class ModernBlueResumeTemplatePdf {
static  Future<pw.Document> buildModernBlueResume({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String dob,
    required String gender,
    required String objective,
    required List<Map<String, TextEditingController>> education,
    required List<Map<String, TextEditingController>> experience,
    required List<String> skills,
    required List<Map<String, String>> projects,
    required List<String> certifications,
    required List<String> languages,
  }) async {
    final pdf = pw.Document();
    final blue = PdfColors.blue800;

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Container(
                color: blue,
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      name,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.Text(email, style: pw.TextStyle(color: PdfColors.white)),
                    pw.Text(phone, style: pw.TextStyle(color: PdfColors.white)),
                    pw.Text(
                      address,
                      style: pw.TextStyle(color: PdfColors.white),
                    ),
                    pw.Text(
                      "DOB: $dob | Gender: $gender",
                      style: pw.TextStyle(color: PdfColors.white),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "Career Objective",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(objective),
              pw.SizedBox(height: 10),

              pw.Text("Education", style: _sectionHeader()),
             ...education.map(
  (e) => pw.Bullet(
    text:
      "${e['degree']?.text ?? ''} - ${e['institute']?.text ?? ''} "
      "(${e['startYear']?.text ?? ''} - ${e['endYear']?.text ?? ''})",
  ),
),


              pw.SizedBox(height: 10),
              pw.Text("Experience", style: _sectionHeader()),
             ...experience.map(
  (e) => pw.Bullet(
    text:
      "${e['position']?.text ?? ''} at ${e['company']?.text ?? ''} "
      "(${e['startYear']?.text ?? ''} - ${e['endYear']?.text ?? ''})",
  ),
),


              pw.SizedBox(height: 10),
              pw.Text("Skills", style: _sectionHeader()),
              pw.Wrap(
                children:
                    skills
                        .map(
                          (s) => pw.Container(
                            margin: const pw.EdgeInsets.all(4),
                            padding: const pw.EdgeInsets.all(6),
                            decoration: pw.BoxDecoration(
                              color: blue,
                              borderRadius: pw.BorderRadius.circular(4),
                            ),
                            child: pw.Text(
                              s,
                              style: pw.TextStyle(color: PdfColors.white),
                            ),
                          ),
                        )
                        .toList(),
              ),

              pw.SizedBox(height: 10),
              pw.Text("Projects", style: _sectionHeader()),
              ...projects.map(
                (p) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      p['title']!,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(p['description']!),
                    pw.SizedBox(height: 5),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),
              pw.Text("Certifications", style: _sectionHeader()),
              ...certifications.map((c) => pw.Bullet(text: c)),

              pw.SizedBox(height: 10),
              pw.Text("Languages", style: _sectionHeader()),
              ...languages.map((l) => pw.Bullet(text: l)),
            ],
      ),
    );

    return pdf;
  }

 static pw.TextStyle _sectionHeader() {
    return pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );
  }
}
