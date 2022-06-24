// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blog/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  late String AurthorName, title, description;
  File? image;
  bool _isLoading = false;
  CRUDmethod crudMethods = CRUDmethod();

  Future pickImage() async {
    {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imaget = File(image.path);
      setState(() => this.image = imaget);
    }
  }

  uploadBlog() async {
    if (image != null) {
      setState(() {
        _isLoading = true;
      });
      await Firebase.initializeApp();
      Reference firebase_storage = FirebaseStorage.instance
          .ref()
          .child('blog_images')
          .child('${randomAlphaNumeric(9)}.jpg');
      final UploadTask task = firebase_storage.putFile(image!);
      var downloadUrl = (await task.then((res) => res.ref.getDownloadURL()));

      final Map<String, String> blogMap = {
        'AurthorName': AurthorName,
        'title': title,
        'description': description,
        'image': downloadUrl,
      };
      crudMethods.adData(blogMap).then((value) {
        Navigator.pop(context);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Flutter',
              style: TextStyle(fontSize: 22),
            ),
            Text('Blog', style: TextStyle(color: Colors.blue)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.file_upload),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(children: [
                GestureDetector(
                  onTap: pickImage,
                  child: image != null
                      ? SizedBox(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(
                            image!,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black45,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(hintText: 'Aurthor Name'),
                        onChanged: (val) {
                          AurthorName = val;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: 'Title'),
                        onChanged: (val) {
                          title = val;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: 'Description'),
                        onChanged: (val) {
                          description = val;
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            ),
    );
  }
}
