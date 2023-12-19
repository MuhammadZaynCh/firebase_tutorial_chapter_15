
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials_chapter_15/Posts/add_posts.dart';
import 'package:firebase_tutorials_chapter_15/Posts/posts_screen.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/firestore/add_firestore_data.dart';

import 'package:firebase_tutorials_chapter_15/ui/signIn_screen.dart';

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class FirestoreListScreen extends StatefulWidget {
  static const String id = 'firestore_list_screen';
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('Users').snapshots();
  final editController = TextEditingController();
  final ref = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: InkWell(
              onTap: (){
                Navigator.pushNamed(
                    context, AddPosts.id);
              },
                child: const Icon(Icons.post_add_outlined)
            ),
            label: 'Add Firebase Post'),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: (){
              Navigator.pushNamed(
                  context, PostScreen.id);
            },
              child: const Icon(Icons.open_in_new_rounded)),
          label: 'Firebase List ',
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
          
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot
                  ) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return ScalingText('Loading...');
                }

                if(snapshot.hasError) {
                  return JumpingText('Error');
                }

                return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context , index){
                          return ListTile(
                            title: Text(
                              snapshot.data!.docs[index]['title'].toString()
                            ),
                            subtitle: Text(
                              'Post ID : ${snapshot.data!.docs[index]['id'].toString()}'
                            ),
                            trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.pop(context);
                                          // ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                                          //   'title' : editController
                                          // }).then((value){
                                          //   Utils().toastMessage('Updated');
                                          // }).onError((error, stackTrace){
                                          //   Utils().toastMessage(error.toString());
                                          //   debugPrint(error.toString());
                                          // });
                                           showPostDialog(snapshot.data!.docs[index]['title'].toString() , snapshot.data!.docs[index]['id'].toString());
                                        },
                                        leading: const Icon(Icons.edit),
                                        title: const Text('Edit'),
                                      )),
                                  PopupMenuItem(
                                      value: 2,
                                      onTap: (){
                                        Navigator.pop(context);
                                        ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                      },
                                      child: const ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete'),
                                      )),
                                ]),
                          );
                        }
                    )
                );
              }
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
                    Navigator.pop(context);

                    ref.doc(id).update({'title' : editController.text.toString()}).then((value){
                      Utils().toastMessage('Post Edited');
                    }).onError((error, stackTrace){
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update')),
            ],
          );
        }
        );
  }
}
