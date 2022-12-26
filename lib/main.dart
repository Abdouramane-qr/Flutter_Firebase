// ignore_for_file: avoid_print, unnecessary_const
//import 'dart:html';

//import 'package:firebase_storage/firebase_storage.dart';
import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect/multiselect.dart';
import 'package:shops/add_movie_page.dart';
//import 'add_movie_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Flutter Firebase',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste Clothes',
            style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const AddPage();
                  },
                  fullscreenDialog: true,
                ),
              );
            },
            icon: const Icon(Icons.add)),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: MoviesInformation(),
      ),
    );
  }
}

class MoviesInformation extends StatefulWidget {
  const MoviesInformation({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MoviesInformationState createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  var nameControll = TextEditingController();
  var yearControll = TextEditingController();
  var posterControll = TextEditingController();
  //final storageRef = FirebaseStorage.instance.ref();
  String imageUrle = '';

  List<String> categorie = [];
  final Stream<QuerySnapshot> _moviesStream =
      FirebaseFirestore.instance.collection('movies').snapshots();

  void addLike(String docID, int likes) {
    var newLiks = likes + 1;
    try {
      FirebaseFirestore.instance.collection('movies').doc(docID).update({
        'likes': newLiks,
      }).then((value) {
        print('Base Firestore à jour');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    //final Stream<QuerySnapshot> moviesStream =FirebaseFirestore.instance.collection('movies').snapshots();

    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      nameControll.text = documentSnapshot['name'];
      posterControll.text = documentSnapshot['poster'];
      yearControll.text = documentSnapshot['year'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: nameControll,
                  decoration:  InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: posterControll,
                  decoration:  InputDecoration(labelText: 'Poster'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: yearControll,
                  decoration:  InputDecoration(
                    labelText: 'Year',
                  ),
                ),
                DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      categorie = x;
                    });
                  },
                  options: const ['XL', 'M', 'L', 'LL'],
                  selectedValues: categorie,
                  whenEmpty: 'Catégorie',
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    child: Text(action == 'create' ? 'Create' : 'Update'),
                    onPressed: () async {
                      final String name = nameControll.text;
                      final String poster = posterControll.text;
                      final String year = yearControll.text;

                      if (action == 'update') {
                        // Update the product

                        FirebaseFirestore.instance
                            .collection('movies')
                            .doc(documentSnapshot!.id)
                            .update({
                          'name': name,
                          'poster': poster,
                          'year': year,
                          'categories': categorie,
                        }).then((value) {
                          print('Base Firestore à jour');
                        });

                        // Clear the text fields
                        nameControll.text = '';
                        posterControll.text = '';

                        // Hide the bottom sheet
                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          );
        });
  }

//fonction de supperssion
  Future<void> _deleteProduct(String docID) async {
    FirebaseFirestore.instance.collection('movies').doc(docID).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    // String imageUrl = '';
    return StreamBuilder<QuerySnapshot>(
      stream: _moviesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CardLoading(
            height: 100,
            width: 100,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            margin: EdgeInsets.only(bottom: 10),
          );
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> movie =
                document.data()! as Map<String, dynamic>;

            return Card(
              //  padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      movie['poster'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        // Press this button to edit a single product
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _createOrUpdate(document)),
                        // This icon button is used to delete a single product
                        IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteProduct(document.id)),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Text('Année de production'),
                          Text(movie['year'].toString()),
                          Row(
                            children: [
                              for (final categorie in movie['categories'])
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Chip(
                                    backgroundColor: Colors.lightBlue,
                                    label: Text(
                                      categorie,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 20,
                                onPressed: () {
                                  addLike(document.id, movie['likes']);
                                },
                                icon: const Icon(Icons.favorite),
                              ),
                              const SizedBox(width: 10),
                              Text('${movie['likes']} likes'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
    // Press this button to edit a single product
  }
}
