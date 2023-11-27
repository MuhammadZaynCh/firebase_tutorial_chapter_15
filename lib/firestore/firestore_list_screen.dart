
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorials_chapter_15/Posts/add_posts.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/firestore/add_firestore_data.dart';

import 'package:firebase_tutorials_chapter_15/widgets/signIn_screen.dart';

import 'package:flutter/material.dart';

class FirestoreListScreen extends StatefulWidget {
  static const String id = 'firestore_list_screen';
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final auth = FirebaseAuth.instance;

  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_sharp),
            label: 'Settings'),
        BottomNavigationBarItem(
          icon: Icon(Icons.open_in_new_rounded),
          label: 'Open Dialog',
        ),
      ]),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: const Text('Firestore List Screen'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushNamed(context, SignInScreen.id);
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [

          const SizedBox(
            height: 10,
          ),

          const Divider(
            color: Colors.green,
            thickness: .8,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
                itemBuilder: (context,index) {
                  return ListTile(
                    title: Text('data'),
                  );
                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddFirestoreData.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showPostDialog(String title , String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: editController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}
