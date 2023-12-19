import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials_chapter_15/Posts/posts_screen.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/ui/forgotten_password.dart';
import 'package:firebase_tutorials_chapter_15/ui/signup_screen.dart';
import 'package:firebase_tutorials_chapter_15/widgets/button_screen.dart';
import 'package:flutter/material.dart';



class SignInScreen extends StatelessWidget {
  static const String id = 'signIn_screen';
   SignInScreen({super.key});

  ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle = ValueNotifier<bool>(false);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    debugPrint('Build 1');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: const Text('Sign In Screen'),
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        helperText: 'enter email e.g. john@gmail.com',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter Email';
                        }
                        return null;
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: toggle,
                      builder: (context , value , child) {
                        debugPrint('build 6');
                        return TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          obscureText: !toggle.value,
                          decoration: InputDecoration(
                              hintText: 'PIN',
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    toggle.value = !toggle.value;
                                    debugPrint('Build 2');
                                  },
                                  child: Icon(toggle.value ? Icons.visibility : Icons.visibility_off))
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Password';
                            }
                            else {
                              return null;
                            }
                          },
                        );
                      }
                    ),
                  ],
                )
            ),
            const SizedBox(height: 50,),
            ValueListenableBuilder(
                valueListenable: loading,
                builder: (context , value , child){
                  return RoundButton(
                    title: 'Log In',
                    isLoading: loading.value,
                    whenTaped: (){
                      loading.value = true ;
                      debugPrint('Build 3');
                      if(_formKey.currentState!.validate()){
                        _auth.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text.toString()
                        ).then((value){
                          Navigator.pushNamed(context , PostScreen.id);
                          loading.value = false ;
                          debugPrint('Build 4');
                        }).onError((error, stackTrace){
                          loading.value = false ;
                          debugPrint('Build 5');
                          debugPrint(error.toString());
                          Utils().toastMessage(error.toString());
                        });
                      }
                    },
                  );
                }),

            SizedBox(
              height: 10,
            ),

            TextButton(onPressed: (){
              Navigator.pushNamed(
                  context, ForgotPasswordScreen.id
              );
            },
                child: const Text('Forgotten Password?')
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
    );
  }
}
