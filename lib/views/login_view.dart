
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/controllers/login_controller.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/views/signup_view.dart';
import 'package:job_tracking_app/widgets/submit_button_widget.dart';
import 'package:job_tracking_app/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 
  LoginController loginController = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // ForgetPasswordController forgetPasswordController = Get.put(
  //   ForgetPasswordController(),
  // );

   void disposeValues(){
    emailController.clear();
    passwordController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text(
          "Login",
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                controller: emailController,
                isPassword: false,
                label: "Email Address",
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                controller: passwordController,
                isPassword: true,
                label: "Password",
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    // showModalBottomSheet(
                    //   context: context,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.vertical(
                    //       top: Radius.circular(20),
                    //     ),
                    //   ),
                    //   isScrollControlled: true,
                    //   backgroundColor: AppColors.white,
                    //   builder:
                    //       (_) => CustomBottomSheet(
                    //         controller:
                    //             forgetPasswordController.emailController.value,
                    //         title: "Forget Password",
                    //         buttonText: "Reset Password",
                    //         onSubmit: () {
                    //           forgetPasswordController.resetPassword(context);
                    //           // Call your reset method here
                    //         },
                    //       ),
                    // );
                  },
          
                  child: Text(
                    "Forget Password?",
                    style: GoogleFonts.poppins(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(() {
                return SubmitButtonWidget(
                  isLoading: loginController.isLoading.value,
                  buttonColor: AppColors.primary,
                  title: "Login",
                  onPress: () {
                      FocusScope.of(context).unfocus();

                    loginController.loginAdmin(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      context: context,
                    ).then((value){
                      disposeValues();
                    }).onError((error,stackTrace){
                      if(kDebugMode){
                        print("Error is $error");
                      }
                    });
                  },
                );
              }),
              const SizedBox(height: 30,),
              Center(
                child: Text("OR",style: GoogleFonts.poppins(color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),),
              ),
              const SizedBox(height: 30,),
              Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.border
                )
              ),
              child: Padding(padding: EdgeInsets.symmetric(
                vertical: 10
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                
                  children: [
                    Text("Sign In with Google",
                    style: GoogleFonts.poppins(color: Colors.black,
                    fontSize: 16),),
                    const SizedBox(width: 10,),
                    Image.asset("assets/images/google_logo.jpeg",
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,)
                  ],
                ),
              ),),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to Register Screen
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupScreen()));
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
