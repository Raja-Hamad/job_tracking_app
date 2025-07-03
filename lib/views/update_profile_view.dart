import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/update_profile_controller.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/utils/extensions/local_storage.dart';
import 'package:job_tracking_app/widgets/submit_button_widget.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';

// ignore: must_be_immutable
class UpdateProfileView extends StatefulWidget {
  String name;
  String email;
  String address;
  String phone;
  String dob;
  String gender;
  String imageUrl;
  UpdateProfileView({
    super.key,
    required this.email,
    required this.name,
    required this.dob,
    required this.gender,
    required this.address,
    required this.phone,
    required this.imageUrl,
  });

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  UpdateProfileController updateProfileController = Get.put(
    UpdateProfileController(),
  );
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  late String selectedGender;
  late String selectedDob;
  @override
  void initState() {
    super.initState();
    updateProfileController.textEditingControllerEmail.value.text =
        widget.email;
    updateProfileController.textEditingControllerName.value.text = widget.name;
    updateProfileController.textEditingControllerAddress.value.text =
        widget.address;
    updateProfileController.textEditingControllerPhone.value.text =
        widget.phone;
    selectedDob = widget.dob;
    selectedGender = widget.gender;
  }

  LocalStorage localStorage = LocalStorage();
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(selectedDob) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDob = picked.toIso8601String().split("T").first; // Only date
      });
    }
  }

  Widget _buildDropdownField(
    String label,
    String value,
    void Function(String?)? onChanged,
  ) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items:
              genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDobField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
        child: Text(
          selectedDob.isNotEmpty ? selectedDob : "Select Date",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
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
                  "Update Profile 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildProfileImage(),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller:
                      updateProfileController.textEditingControllerName.value,
                  isPassword: false,
                  label: "Name",
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller:
                      updateProfileController.textEditingControllerEmail.value,
                  isPassword: false,
                  label: "Email",
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller:
                      updateProfileController
                          .textEditingControllerAddress
                          .value,
                  isPassword: false,
                  label: "Adress",
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller:
                      updateProfileController.textEditingControllerPhone.value,
                  isPassword: false,
                  label: "Contact Number",
                ),
                const SizedBox(height: 16),
                _buildDropdownField("Gender", selectedGender, (value) {
                  if (value != null) {
                    setState(() {
                      selectedGender = value;
                    });
                  }
                }),
                const SizedBox(height: 16),
                _buildDobField(),
                const SizedBox(height: 40),
                Obx(() {
                  return SubmitButtonWidget(
                    buttonColor: AppColors.primary,
                    title: "Update",
                    isLoading: updateProfileController.isLoading.value,
                    onPress: () {
                      updateProfileController
                          .updateProfile(
                            updateProfileController
                                    .textEditingControllerEmail
                                    .value
                                    .text
                                    .isEmpty
                                ? widget.email
                                : updateProfileController
                                    .textEditingControllerEmail
                                    .value
                                    .text,
                            updateProfileController
                                    .textEditingControllerName
                                    .value
                                    .text
                                    .isEmpty
                                ? widget.name
                                : updateProfileController
                                    .textEditingControllerName
                                    .value
                                    .text,
                            updateProfileController.dob.value.isEmpty
                                ? widget.dob.toString()
                                : updateProfileController.dob.value,

                            updateProfileController.gender.value.isEmpty
                                ? widget.gender.toString()
                                : updateProfileController.gender.value
                                    .toString(),
                            updateProfileController
                                    .textEditingControllerPhone
                                    .value
                                    .text
                                    .isEmpty
                                ? widget.phone.toString()
                                : updateProfileController
                                    .textEditingControllerPhone
                                    .value
                                    .text
                                    .trim()
                                    .toString(),
                            updateProfileController
                                    .textEditingControllerAddress
                                    .value
                                    .text
                                    .isEmpty
                                ? widget.address.toString()
                                : updateProfileController
                                    .textEditingControllerAddress
                                    .value
                                    .text
                                    .trim()
                                    .toString(),
                            updateProfileController.selectedImage.value != null
                                ? File(
                                  updateProfileController
                                      .selectedImage
                                      .value!
                                      .path,
                                )
                                : null,
                            context,
                          )
                          .then((value) async {
                            await localStorage.clear("userName");
                            await localStorage.clear("email");
                            await localStorage.clear('phone');
                            await localStorage.clear("address");
                            await localStorage.clear('dob');
                            await localStorage.clear("gender");
                            await localStorage.clear("imageUrl");
                          });
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Obx(() {
        return InkWell(
          onTap: updateProfileController.pickImageFromGallery,
          child:
              updateProfileController.selectedImage.value != null
                  ? ClipOval(
                    child: Image.file(
                      updateProfileController.selectedImage.value!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                  : ClipOval(
                    child: Image.network(
                      widget.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => CircleAvatar(
                            backgroundColor: AppColors.white,
                            radius: 50,
                            child: Icon(Icons.person, size: 40),
                          ),
                    ),
                  ),
        );
      }),
    );
  }
}
