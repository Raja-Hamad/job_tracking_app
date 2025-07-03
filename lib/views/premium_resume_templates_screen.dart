import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/widgets/generate_resume_pdf.dart';
import 'package:job_tracking_app/widgets/modern_blue_resume_template_pdf.dart';
import 'package:job_tracking_app/widgets/rewarded_ad_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
// import purchase handler if using in_app_purchase

class PremiumResumeTemplatesScreen extends StatefulWidget {
  final List<Map<String, TextEditingController>> educationListData;
  final String name;
  final String email;
  final String phone;
  final String address;
  final List<Map<String, TextEditingController>> projects1;
  final String gender;
  final String dob;
  final List<Map<String, TextEditingController>> workList;
  final List<String> certifications;
  final List<String> skills;

  final List<String> projects;

  final List<String> languages;
  final String objective;

  const PremiumResumeTemplatesScreen({
    super.key,
    required this.address,
    required this.projects1,
    required this.dob,
    required this.email,
    required this.gender,
    required this.name,
    required this.phone,
    required this.educationListData,
    required this.workList,
    required this.certifications,
    required this.languages,
    required this.objective,
    required this.projects,
    required this.skills,
  });
  @override
  State<PremiumResumeTemplatesScreen> createState() =>
      _PremiumResumeTemplatesScreenState();
}

class _PremiumResumeTemplatesScreenState
    extends State<PremiumResumeTemplatesScreen> {
  bool hasPremiumAccess = false;

  final List<Map<String, dynamic>> templates = [
    {"title": "Classic", "isPremium": false},
    {"title": "Modern Blue", "isPremium": true},
    {"title": "Professional Gray", "isPremium": true},
    {"title": "Elegant Black", "isPremium": true},
    {"title": "Bold Red", "isPremium": true},
  ];

  @override
  void initState() {
    super.initState();
    checkPremiumStatus();
  }

  Future<void> checkPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasPremiumAccess = prefs.getBool('hasPremiumAccess') ?? false;
    });
  }

  Future<void> unlockPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasPremiumAccess', true);
    setState(() => hasPremiumAccess = true);
  }

  void onTemplateTap(bool isPremium) {
    if (!isPremium || hasPremiumAccess) {
      // Navigate to preview/generate page
      if (kDebugMode) {
        print("Open template");
      }
    } else {
      _showUnlockOptions();
    }
  }

  void callDesgins(index) async {
    switch (index) {
      case 0:
        GenerateResumePdf.generateResumePdf(
          name: widget.name,
          email: widget.email,
          phone: widget.phone,
          address: widget.address,
          gender: widget.gender,
          dob: widget.dob,
          objective: widget.objective,
          educationList: widget.educationListData,
          experienceList: widget.workList,
          skills: widget.skills,
          projects: widget.projects,
          languages: widget.languages,
          certifications: widget.certifications,
        );
        break;
      case 1:
        final pdfDoc = await ModernBlueResumeTemplatePdf.buildModernBlueResume(
          name: widget.name,
          email: widget.email,
          phone: widget.phone,
          address: widget.address,
          gender: widget.gender,
          dob: widget.dob,
          objective: widget.objective,
          education: widget.educationListData,
          experience: widget.workList,
          skills: widget.skills,
          projects:
              widget.projects1.map((project) {
                return {
                  'title': project['title']?.text ?? '',
                  'description': project['description']?.text ?? '',
                };
              }).toList(),
          languages: widget.languages,
          certifications: widget.certifications,
        );

        // Save and open the PDF
        await GenerateResumePdf1.saveAndOpenPdf(
          pdfDoc,
          'modern_blue_resume.pdf',
          // ignore: use_build_context_synchronously
          context,
        );
        break;
    }
  }

  void _showUnlockOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Unlock Premium Templates",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Choose an option to unlock all premium resume designs.",
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                icon: const Icon(Icons.play_circle_fill),
                label: const Text("Watch an ad to unlock"),
                onPressed: () {
                  Navigator.pop(context);
                  RewardedAdHelper.loadRewardedAd(() async {
                    await unlockPremium();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Premium templates unlocked 🎉"),
                      ),
                    );
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  minimumSize: const Size(double.infinity, 48),
                ),
                icon: const Icon(Icons.attach_money),
                label: const Text("Buy premium access"),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Purchase flow not implemented"),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resume Templates", style: GoogleFonts.poppins()),
        backgroundColor: AppColors.primary,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: templates.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          final template = templates[index];
          final isLocked = template["isPremium"] && !hasPremiumAccess;

          return GestureDetector(
            onTap: () {
              onTemplateTap(template["isPremium"]);
              callDesgins(index);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child:
                        isLocked
                            ? const Icon(Icons.lock, color: Colors.redAccent)
                            : const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                  ),
                  Center(
                    child: Text(
                      template["title"],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


                  // await GenerateResumePdf.generateResumePdf(
                  //   name: widget.name,
                  //   email: widget.email,
                  //   phone: widget.phone,
                  //   address: widget.address,
                  //   gender: widget.gender,
                  //   dob: widget.dob,
                  //   objective: objectiveController.text.trim(),
                  //   educationList: widget.educationListData,
                  //   experienceList: widget.workList,
                  //   skills: skills,
                  //   projects: projectDescriptions,
                  //   languages: languages,
                  //   certifications: certifications,
                  // ).then((value){
                  //   InterstitialAdHelper.showInterstitialAd();
                  // });
