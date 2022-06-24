// ignore_for_file: prefer_const_constructors, camel_case_types, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/services/crud.dart';
import 'package:flutter_blog/views/create_blog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CRUDmethod crudMethods = CRUDmethod();
  Stream<QuerySnapshot>? blogStream;

  Widget bloglist() {
    return Container(
      child: blogStream != null
          ? Column(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: blogStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    } else {
                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return blogTile(
                              title:
                                  snapshot.data!.docs[index].get('title') ?? '',
                              description: snapshot.data!.docs[index]
                                      .get('description') ??
                                  '',
                              imgURL:
                                  snapshot.data!.docs[index].get('image') ?? '',
                              authorName: snapshot.data!.docs[index]
                                      .get('AurthorName') ??
                                  '',
                            );
                          });
                    }
                  },
                )
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  @override
  void initState() {
    crudMethods.getData().then((value) {
      setState(() {
        blogStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
        child: bloglist(),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.amber,
        hoverColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateBlog(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class blogTile extends StatelessWidget {
  late String imgURL, title, description, authorName;
  blogTile(
      {Key? key,
      required this.imgURL,
      required this.title,
      required this.description,
      required this.authorName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              imgURL,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  description,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(authorName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
