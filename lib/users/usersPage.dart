// ignore_for_file: avoid_print, unnecessary_const, file_names
//import 'dart:html';

//import 'package:firebase_storage/firebase_storage.dart';
import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shops/add_movie_page.dart';
//import 'add_movie_page.dart';

import 'calendar_page.dart';

class HomeUserPage extends StatelessWidget implements PreferredSizeWidget {
  const HomeUserPage({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products Liste',
          style: GoogleFonts.nunito(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,

        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_outline_rounded,
              )),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
        ],
        backgroundColor: const Color.fromARGB(255, 42, 5, 5),
        //elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
            icon: const Icon(Icons.arrow_back)),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only()),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: const [SearchSection(), UserViewsInfo()],
      )),
    );
  }
}

// class HomeUserPageUserNavBar extends StatelessWidget {
//   const HomeUserPageUserNavBar({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Liste Cloth'),
//         leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (BuildContext context) {
//                     return const UserViewsInfo();
//                   },
//                   fullscreenDialog: true,
//                 ),
//               );
//             },
//             icon: const Icon(Icons.arrow_back_ios_new)),
//       ),
//       body: const SingleChildScrollView(
//         child: UserViewsInfo(),
//       ),
//     );
//   }
// }

class UserViewsInfo extends StatefulWidget {
  const UserViewsInfo({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _UserViewsInfoState createState() => _UserViewsInfoState();
}

class _UserViewsInfoState extends State<UserViewsInfo> {
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

            return Container(
              margin: const EdgeInsets.all(10),
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]),
              //  padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ]),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 5,
                          right: -15,
                          child: MaterialButton(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            onPressed: () {
                              addLike(document.id, movie['likes']);
                            },
                            child: const Icon(
                              
                              Icons.favorite_outline_rounded,
                              color: d_green,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${movie['likes']} likes'),
                      ],
                    ),
                  ),

Container(
   margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  movie['name'],
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  '\$' + movie['year'],
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
              
            ),
            
),






                  SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        // Press this button to edit a single product
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        // This icon button is used to delete a single product
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {},
                        ),
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
                          // Row(
                          //   children: [
                          //     for (final categorie in movie['categories'])
                          //       Padding(
                          //         padding: const EdgeInsets.only(right: 5),
                          //         child: Chip(
                          //           backgroundColor: Colors.lightBlue,
                          //           label: Text(
                          //             categorie,
                          //             style:
                          //                 const TextStyle(color: Colors.white),
                          //           ),
                          //         ),
                          //       ),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     IconButton(
                          //       padding: EdgeInsets.zero,
                          //       constraints: const BoxConstraints(),
                          //       iconSize: 20,
                          //       onPressed: () {
                          //         addLike(document.id, movie['likes']);
                          //       },
                          //       icon: const Icon(Icons.favorite),
                          //     ),
                          //     const SizedBox(width: 10),
                          //     Text('${movie['likes']} likes'),
                          //   ],
                          // ),
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

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 247, 246, 248),
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child:  TextField(
                    decoration: InputDecoration(
                      hintText: 'London',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AddPage();
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: d_green,
                    shape: const CircleBorder(),
                    shadowColor: const Color.fromARGB(255, 58, 54, 54),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose date',
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '12 Dec - 22 Dec',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of Rooms',
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1 Room - 2 Adults',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
