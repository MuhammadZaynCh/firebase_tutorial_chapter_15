import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/widgets/button_screen.dart';
import 'package:flutter/material.dart';



class AddFirestoreData extends StatefulWidget {
  static const String id = 'add_firestore_data';
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {

  bool loading = false ;
  final firestore = FirebaseFirestore.instance.collection('Users');
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
                  String documentationID = DateTime.now().millisecondsSinceEpoch.toString();
                  firestore.doc(documentationID).set({
                    'title' : postController.text.toString(),
                    'id' : documentationID,
                  }).then((value){
                    setState(() {
                      loading = false ;
                    });
                    Utils().toastMessage('Firestore Data Posted');
                  }).onError((error, stackTrace){
                    setState(() {
                      loading = false ;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
