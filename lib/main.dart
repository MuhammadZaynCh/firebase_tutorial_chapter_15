import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tutorials_chapter_15/Posts/add_posts.dart';
import 'package:firebase_tutorials_chapter_15/Posts/posts_screen.dart';
import 'package:firebase_tutorials_chapter_15/firestore/add_firestore_data.dart';
import 'package:firebase_tutorials_chapter_15/firestore/firestore_list_screen.dart';

import 'package:firebase_tutorials_chapter_15/ui/login_with_phone_number.dart';
import 'package:firebase_tutorials_chapter_15/ui/signup_screen.dart';
import 'package:firebase_tutorials_chapter_15/ui/splash_screen.dart';

import 'package:firebase_tutorials_chapter_15/widgets/signIn_screen.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id : (context) => const SplashScreen(),
        // LoginScreen.id : (context) => LoginScreen(),
        SignInScreen.id : (context) => SignInScreen(),
        SignUpScreen.id : (context) => SignUpScreen(),
        LoginWithPhoneNumber.id : (context) => const LoginWithPhoneNumber(),
        PostScreen.id : (context) => const PostScreen(),
        AddPosts.id : (context) => const AddPosts(),
        FirestoreListScreen.id : (context) => const FirestoreListScreen(),
        AddFirestoreData.id : (context) => const AddFirestoreData(),
      },
    );
  }
}


