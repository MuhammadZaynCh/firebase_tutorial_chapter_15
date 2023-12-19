
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorials_chapter_15/firebase_services/utils.dart';
import 'package:firebase_tutorials_chapter_15/widgets/button_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


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

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Posts');

  File? _image ;
  final picker = ImagePicker();
  Future getGalleryImage()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery , imageQuality: 80);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        debugPrint('No image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                maxLines: 12,
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
              }),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: (){
                  getGalleryImage();
                },
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    ),
                  ),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      :const Icon(Icons.image_outlined, size: 100,),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              RoundButton(
                  title: "Upload",
                  isLoading: loading,
                  whenTaped: ()async{

                    setState(() {
                      loading = true;
                    });

                    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/zainpics/' + DateTime.now().millisecondsSinceEpoch.toString());
                    firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

                    Future.value(uploadTask).then((value)async{
                      var newUrl = await ref.getDownloadURL();

                      String newId = DateTime.now().microsecondsSinceEpoch.toString();
                      databaseRef.child(newId).set({
                        'id' : newId,
                        'title' : newUrl.toString()
                      }).then((value){
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage('Image Uploaded');
                      }).onError((error, stackTrace){
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage(error.toString());
                      });
                    });
              })
            ],
          ),
        ),
      ),
    );
  }
}
