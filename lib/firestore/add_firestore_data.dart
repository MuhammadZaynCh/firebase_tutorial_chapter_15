import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/widgets/button_screen.dart';
import 'package:flutter/material.dart';



class AddFirestoreData extends StatefulWidget {
  static const String id = 'Add_posts';
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {

  bool loading = false ;
  final firebaseRef = FirebaseDatabase.instance.ref('Posts');
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Firestore Data'),
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
                  String id = DateTime.now().microsecondsSinceEpoch.toString() ;
                  firebaseRef.child(id).set(
                      {
                        'id' : id,
                        'title' : postController.text
                      }
                  ).then((value){
                    setState(() {
                      Utils().toastMessage('Posted');
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
