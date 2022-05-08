import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbgelectric/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Category>> getCategory() async {
    var ref = _db.collection('category');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var categories = data.map((d) => Category.fromJson(d));
    return categories.toList();
  }

  Future<List<Item>> getItems() async {
    var ref = _db.collection('item').orderBy('category');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var categories = data.map((d) => Item.fromJson(d));
    return categories.toList();
  }

  Future<Item> getItem(String itemId) async {
    var ref = _db.collection('item').doc(itemId);
    var snapshot = await ref.get();
    return Item.fromJson(snapshot.data() ?? {});
  }

  Future<List<Showcase>> getShowcase() async {
    var ref = _db.collection('showcase');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var showcases = data.map((d) => Showcase.fromJson(d));
    return showcases.toList();
  }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List? data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data!);
    } on FirebaseException {
      return null;
    }
  }
}
