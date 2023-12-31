
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials_chapter_15/ui/signIn_screen.dart';
import 'package:flutter/cupertino.dart';

import '../Posts/posts_screen.dart';

class SplashServices{

  void islogin(BuildContext context){

    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if(user != null){
      Timer(
          const Duration(seconds: 3),
              () => Navigator.pushNamed(
              context, PostScreen.id)
      );
    }else{
      Timer(
          const Duration(seconds: 3),
              () => Navigator.pushNamed(
              context, SignInScreen.id)
      );
    }


  }
}