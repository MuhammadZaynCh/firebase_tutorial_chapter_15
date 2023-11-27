import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorials_chapter_15/Posts/add_posts.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/ui/login_screen.dart';
import 'package:firebase_tutorials_chapter_15/widgets/signIn_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  static const String id = 'Posts_screen';
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Posts');
  final searchFilter = TextEditingController();
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
        title: const Text('Post Screen'),
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
          // Expanded(
          //     child: StreamBuilder(
          //         stream: ref.onValue,
          //         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //           if (!snapshot.hasData) {
          //             return CupertinoActivityIndicator();
          //           }
          //           else {
          //             Map<dynamic, dynamic> map =
          //                 snapshot.data!.snapshot.value as dynamic;
          //             List<dynamic> list = [];
          //             list.clear();
          //             list = map.values.toList();
          //
          //             return ListView.builder(
          //                 itemCount: snapshot.data!.snapshot.children.length,
          //                 itemBuilder: (context, index) {
          //                   return ListTile(
          //                     title: Text(list[index]['title']),
          //                     subtitle: Text(list[index]['id']),
          //                   );
          //                 });
          //           }
          //         })
          // ),

          const SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                  labelText: 'Search', border: OutlineInputBorder()),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          const Divider(
            color: Colors.green,
            thickness: .8,
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();

                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text('ID: ${snapshot.child('id').value.toString()}'),
                      trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: (){
                                        Navigator.pop(context);
                                        showPostDialog(title, snapshot.child('id').value.toString());
                                      },
                                      leading: const Icon(Icons.edit),
                                      title: const Text('Edit'),
                                    )),
                                PopupMenuItem(
                                    value: 1,
                                    onTap: (){
                                      Navigator.pop(context);
                                      ref.child(snapshot.child('id').value.toString()).remove();
                                    },
                                    child: const ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                    )),
                              ]),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle:
                          Text('ID: ${snapshot.child('id').value.toString()}'),
                      trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    showPostDialog(title, snapshot.child('id').value.toString());
                                  },
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Edit'),
                                )),
                            PopupMenuItem(
                                value: 2,
                                onTap: (){
                                  Navigator.pop(context);
                                  ref.child(snapshot.child('id').value.toString()).remove();
                                },
                                child: const ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                )),
                          ]),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddPosts.id);
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
                    ref.child(id).update({'title' : editController.text.toString()}).then((value){
                      Utils().toastMessage('Post Edited');
                    }).onError((error, stackTrace){
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}
