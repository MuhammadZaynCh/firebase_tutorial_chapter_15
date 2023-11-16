import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tutorials_chapter_15/Posts/posts_screen.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/ui/login_screen.dart';
import 'package:firebase_tutorials_chapter_15/ui/login_with_phone_number.dart';
import 'package:firebase_tutorials_chapter_15/widgets/button_screen.dart';
import 'package:firebase_tutorials_chapter_15/widgets/signIn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class SignUpScreen extends StatelessWidget {
  static const String id = 'signup_screen';
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle = ValueNotifier<bool>(false);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    debugPrint('build 1');
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true ;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Sign Up '),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 50,),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: 'Full Name',
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Enter Name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10,),

                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Country',
                            prefixIcon: Icon(Icons.flag),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Enter Country';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10,),

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

                        const SizedBox(height: 10,),

                        ValueListenableBuilder(
                            valueListenable: toggle,
                            builder: (context , value , child) {
                              return TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                controller: passwordController,
                                obscureText: !toggle.value,
                                decoration: InputDecoration(
                                  hintText: 'Create Password(Atleast 6 character)',
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        toggle.value = !toggle.value;
                                        debugPrint('Build 2');
                                      },
                                      child: Icon(toggle.value ? Icons.visibility : Icons.visibility_off))
                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter Password';
                                  }
                                  else{
                                    return null;
                                  }
                                },
                              );
                            }
                        )

                      ],
                    )
                ),
                const SizedBox(height: 50,),
                ValueListenableBuilder(
                    valueListenable: loading,
                    builder: (context , value , child){
                      return RoundButton(
                        title: 'Sign In',
                        isLoading: loading.value,
                        whenTaped: (){
                          loading.value = true;
                          debugPrint('build 2');
                          if(_formKey.currentState!.validate()){
                            debugPrint('build 3');
                            _auth.createUserWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString()).
                            then((value) {
                              Navigator.pushNamed(context , PostScreen.id);
                                  loading.value = false ;
                            }).onError((error, stackTrace){
                              debugPrint('There is an error');
                              loading.value = false ;
                              Utils().toastMessage(error.toString());
                              debugPrint('build 6');
                            });
                          }
                        },
                      );
                    }
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account ?"),
                    TextButton(onPressed: (){
                      debugPrint('build 6');
                      Navigator.pushNamed(context, SignInScreen.id);
                    },
                        child: const Text('Log In'))
                  ],
                ),

                const SizedBox(height: 30,),

                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, LoginWithPhoneNumber.id);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.black
                        )
                    ),
                    child: const Center(
                        child: Text('Join with Phone Number')
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}




