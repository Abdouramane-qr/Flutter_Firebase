import 'dart:io';
//import 'dart:typed_data';

import 'package:shops/models/clothesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  String? userID, carID;
  DatabaseService({this.userID, this.carID});
  // Déclaraction et Initialisation
  CollectionReference clot = FirebaseFirestore.instance.collection('movies');
  FirebaseStorage storage = FirebaseStorage.instance;

  // upload de l'image vers Firebase Storage
  Future<String> uploadFile(File file, XFile fileWeb) async {
    Reference reference = storage.ref().child('movies/${DateTime.now()}.png');
    Uint8List imageTosave = await fileWeb.readAsBytes();
    SettableMetadata metaData = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = kIsWeb
        ? reference.putData(imageTosave, metaData)
        : reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}

void addClothes(Clothe clothe) {
  FirebaseFirestore.instance.collection('movies').add({
    "cID": clothe.cID,
    "cName": clothe.cName,
    "cUrlImg": clothe.cUrlImg,
    "cUserID": clothe.cUserID,
    "cUserName": clothe.cUserName,
    "cCategorie": clothe.cCategories,
    "cPoster": clothe.cPoster,
    "cTimestamp": clothe.cTimestamp,
    "coTimestamp": FieldValue.serverTimestamp(),
    "cFavoriteCount": 0,
  });
}

// suppression de la voiture
Future<void> deleteCar(String carID) =>
    FirebaseFirestore.instance.collection('movies').doc(carID).delete();

// Récuperation de toutes les voitures en temps réel
Stream<List<Clothe>> get cars {
  Query queryCars = FirebaseFirestore.instance
      .collection('movies')
      .orderBy('carTimestamp', descending: true);
  return queryCars.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Clothe(
        cID: doc.id,
        cName: doc.get('cName'),
        cUrlImg: doc.get('cUrlImg'),
        cUserID: doc.get('cUserID'),
        cUserName: doc.get('cUserName'),
        cCategories: doc.get('cCategories'),
        cPoster: doc.get('cPoster'),
        cFavoriteCount: doc.get('cFavoriteCount'),
        cTimestamp: doc.get('cTimestamp'),
      );
    }).toList();
  });
}

Future<Clothe> singleCar(String carID) async {
  final doc =
      await FirebaseFirestore.instance.collection('movies').doc(carID).get();
  return Clothe(
    cID: doc.id,
    cName: doc.get('cName'),
    cUrlImg: doc.get('cUrlImg'),
    cUserID: doc.get('cUserID'),
    cUserName: doc.get('cUserName'),
    cCategories: doc.get('cCategories'),
    cPoster: doc.get('cPoster'),
    cFavoriteCount: doc.get('cFavoriteCount'),
    cTimestamp: doc.get('cTimestamp'),
  );
}
