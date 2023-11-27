import 'package:firebase_tutorials_chapter_15/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.islogin(context);
  }
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: Text('Firebase Tutorial App'),
      ),
    );
  }
}


