import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/views/login_view.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    goToLoginScreen();
  }

  @override
  void dispose() {
    animationController.dispose(); // Always dispose controllers
    super.dispose();
  }

  goToLoginScreen() {
    Timer.periodic(
      const Duration(seconds: 4),
      (value) => {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/json/splash_animation.json",
              repeat: true,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              reverse: true,
              controller: animationController,
              onLoaded: (composition) {
                animationController.duration = composition.duration;
                animationController.repeat();
              },
            ),
            const SizedBox(height: 30),
            Text(
              "Job Tracking App",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
