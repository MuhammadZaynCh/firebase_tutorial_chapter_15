import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials_chapter_15/Posts/posts_screen.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/widgets/button_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class VerifyCode extends StatefulWidget {
  static const String id = 'verification_code_screen';
  final String verifyID ;
  const VerifyCode
      ({
        super.key,
    required this.verifyID,
  });

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}
class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false ;
  final verifyTokenController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Code'),
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
              const Column(
                children: [
                  Text('Enter code received from SMS',
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
              Column(
                children: [
                  PinCodeTextField(
                    controller: verifyTokenController,
                    appContext: context,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: false,
                    obscuringCharacter: '*',
                    length: 6,
                    onChanged: (value){

                    },
                  )
                ],
              ),
              // TextFormField(
              //   controller: verifyTokenController,
              //   decoration: const InputDecoration(
              //       hintText: 'Mobile #:'
              //   ),
              // ),
              const SizedBox(
                height: 50,
              ),
              RoundButton(
                  title: 'Verify & Continue',
                  isLoading: loading,
                  whenTaped: ()async{
                    setState(() {
                      loading = true;
                    });
                    final credentials = PhoneAuthProvider.credential(
                        verificationId: widget.verifyID,
                        smsCode: verifyTokenController.text.toString()
                    );
                    try {
                      await auth.signInWithCredential(credentials);
                      Navigator.pushNamed(context, PostScreen.id);
                    } catch (e){
                      setState(() {
                        loading = false ;
                      });
                      debugPrint(e.toString());
                      Utils().toastMessage(e.toString());
                    }
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
