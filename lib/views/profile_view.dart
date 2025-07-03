
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/utils/extensions/local_storage.dart';
import 'package:job_tracking_app/views/update_profile_view.dart';
import 'package:job_tracking_app/widgets/reusable_containr_widget.dart';
import 'package:job_tracking_app/widgets/submit_button_widget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  LocalStorage localStorage = LocalStorage();
  String? email;
  String? name;
  String? address;
  String? phone;
  String? dob;
  String? gender;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues() async {
    email = await localStorage.getValue("email");
    name = await localStorage.getValue("userName");
    address = await localStorage.getValue("address");
    phone = await localStorage.getValue("phone");
    dob = await localStorage.getValue("dob");
    gender = await localStorage.getValue("gender");
    imageUrl = await localStorage.getValue("imageUrl");

    if (kDebugMode) {
      print("Name of the user is ${name ?? ""}");
      print("email of the users is ${email ?? ""}");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child:
                        imageUrl != null && imageUrl!.isNotEmpty
                            ? Image.network(
                              imageUrl!,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                            : Image.asset(
                              'assets/images/dummy_doctor.jpeg', // Use a local placeholder image
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                  ),
                ),

                ReusableContainerWidget(
                  title: "Name",
                  containerText: name ?? "",
                ),
                const SizedBox(height: 16),
                ReusableContainerWidget(
                  containerText: email ?? "",
                  title: "Email",
                ),
                const SizedBox(height: 16),
                ReusableContainerWidget(
                  containerText: address ?? "",
                  title: "Address",
                ),
                const SizedBox(height: 16),
                ReusableContainerWidget(
                  containerText: phone ?? "",
                  title: "Contact Number",
                ),
                const SizedBox(height: 16),
                ReusableContainerWidget(
                  containerText: dob ?? "",
                  title: "Date Of Birth",
                ),
                const SizedBox(height: 16),
                ReusableContainerWidget(
                  containerText: gender ?? "",
                  title: "Gender",
                ),
                const SizedBox(height: 40),
                SubmitButtonWidget(
                  buttonColor: AppColors.primary,
                  title: "Update Profile",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => UpdateProfileView(
                              phone: phone ?? "",
                              imageUrl: imageUrl ?? "",
                              address: address ?? "",
                              email: email ?? "",
                              name: name ?? "",
                              dob: dob ?? "",
                              gender: gender ?? "",
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
