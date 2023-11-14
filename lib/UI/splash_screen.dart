import 'package:chatapp/Firebase_Services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashservices = SplashServices();

  @override
  void initState() {
    super.initState();
    splashservices.islogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Quiz \n App",
          style: TextStyle(
            fontFamily: AutofillHints.birthdayDay,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.red, // Accessing themeColor correctly
          ),
        ),
      ),
    );
  }
}
