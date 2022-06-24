import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/cupertino.dart';

class CRUDmethod {
  Future<dynamic> adData(blogData) async {
    FirebaseFirestore.instance
        .collection("blogs")
        .add(blogData)
        .catchError((e) {});
    return blogData;
  }

  getData() async {
    await Firebase.initializeApp();
    return FirebaseFirestore.instance.collection("blogs").snapshots();
  }
}
