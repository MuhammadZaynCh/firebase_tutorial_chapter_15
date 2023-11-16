import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/widgets/button_screen.dart';
import 'package:flutter/material.dart';



class AddPosts extends StatefulWidget {
  static const String id = 'Add_posts';
  const AddPosts({super.key});

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {

  bool loading = false ;
  final firebaseRef = FirebaseDatabase.instance.ref('Posts');
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              maxLines: 10,
              minLines: 1,
              controller: postController,
              decoration: const InputDecoration(
                hintText: 'What is in Your Mind?',
                border: OutlineInputBorder(

                )
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Post',
                  isLoading: loading,
                whenTaped: (){
                  setState(() {
                    loading = true ;
                  });
                  firebaseRef.child(
                      DateTime.now().microsecondsSinceEpoch.toString()).set(
                    {
                      'id' : DateTime.now().millisecondsSinceEpoch.toString(),
                      'title' : postController.text
                    }
                  ).then((value){
                    setState(() {
                      loading = false ;
                    });
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false ;
                    });
                  });
            })
          ],
        ),
      ),
    );
  }
}
