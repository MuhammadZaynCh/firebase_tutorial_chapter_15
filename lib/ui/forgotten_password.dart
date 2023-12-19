import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/ui/signup_screen.dart';
import 'package:firebase_tutorials_chapter_15/widgets/button_screen.dart';
import 'package:flutter/material.dart';


class ForgotPasswordScreen extends StatelessWidget {
  static const String id = 'forgotten_password';
  ForgotPasswordScreen({super.key});
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Your Password'),
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage('assets/login-image.png')
              ),
              const Text(
                'We will send a Password Reset Email to this account.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.black87, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(title: 'Send', whenTaped:(){
                auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                  Utils().toastMessage('Mail Sent to Your Account');
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                });
              }),
          
              SizedBox(
                height: 10,
              ),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account ?"),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(
                        context, SignUpScreen.id
                    );
                  },
                      child: const Text('Sign Up')
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
