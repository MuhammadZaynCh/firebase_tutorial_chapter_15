import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/ui/verification_code_screen.dart';
import 'package:firebase_tutorials_chapter_15/widgets/button_screen.dart';
import 'package:flutter/material.dart';



class LoginWithPhoneNumber extends StatefulWidget {
  static const String id = 'login_with_phone_number';
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}
class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false ;
  final phoneNumberController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    debugPrint('build 1');
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogUp with Phone'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                    image: AssetImage('assets/login-image.png')
                ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: const [

                  Text('We will send you a 6 digits one time Code on this mobile number.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17
                  ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Mobile #: +923698745621'
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              RoundButton(
                  title: 'Generate OTP',
                  isLoading: loading,
                  whenTaped: (){
                    setState(() {
                      loading = true ;
                    });
                      try {
                        auth.verifyPhoneNumber(
                          phoneNumber: phoneNumberController.text,
                          verificationCompleted: (_){
                            setState(() {
                              loading = false ;
                            });
                          },
                          verificationFailed: (e){
                            Utils().toastMessage(e.toString());
                            debugPrint(e.toString());
                            setState(() {
                              loading = false ;
                            });
                          },
                          codeSent: (String verificationId , int? token){
                            setState(() {
                              loading = false ;
                            });
                            Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => VerifyCode(
                                    verifyID: verificationId
                                ))
                            );
                          },
                          codeAutoRetrievalTimeout: (e){
                            Utils().toastMessage(e.toString());
                            debugPrint(e.toString());
                            setState(() {
                              loading = false ;
                            });
                          });
                      } catch (e){
                        debugPrint(e.toString());
                        setState(() {
                          loading = false ;
                        });
                      }

              }),

            ],
          ),
        ),
      ),
    );
  }
}
