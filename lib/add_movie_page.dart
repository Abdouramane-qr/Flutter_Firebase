import 'dart:core';
import 'dart:io';
//import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final posterController = TextEditingController();
  //final storageRef = FirebaseStorage.instance.ref();
  String imageUrl = '';
  FirebaseStorage storage = FirebaseStorage.instance;

  List<String> categories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clothes'),
      ),
      extendBody:true,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Nom: '),
                  Expanded(
                    child: TextField(
                      decoration:  InputDecoration(
                        hintTextDirection: TextDirection.ltr,
                        hintText: 'Enter product name',
                        border: InputBorder.none,
                      ),
                      controller: nameController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Année: '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a date  yyy/mm/dd',
                      ),
                      controller: yearController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Poster: '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a Poster',
                      ),
                      controller: posterController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                setState(() {
                  categories = x;
                });
              },
              options: const ['XL', 'M', 'L', 'LL'],
              selectedValues: categories,
              whenEmpty: 'Catégorie',
            ),
            const SizedBox(
              height: 20,
            ),
//Importation de limage

            IconButton(
              onPressed: () async {
                /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */
                /*Step 1:Pick image*/
                //Install image_picker
                //Import the corresponding library

                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                //print('${file?.path}');

                if (file == null) return;
                //Import dart:core
                String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();

                /*Step 2: Upload to Firebase storage*/
                //Install firebase_storage
                //Import the library

                //Get a reference to storage root

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('poster');

                //Create a reference for the image to be stored
                Reference referenceImageToUpload =
                    referenceDirImages.child(uniqueFileName);

                //Handle errors/success
                try {
                  //   //Store the file
                  await referenceImageToUpload.putFile(File(file.path));
                  //   //Success: get the download URL
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                } catch (error) {
                  //   // error occurred

                }
              },
              icon: const Icon(Icons.image),
              tooltip: 'Choose a picture  from gallery',
              iconSize: 70,
            ),

            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () async {
                if (imageUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload an image')));

                  return;
                }

                FirebaseFirestore.instance.collection('movies').add({
                  'name': nameController.value.text,
                  'year': yearController.value.text,
                  'poster': posterController.value.text,
                  'categories': categories,
                  'image': imageUrl,
                  'likes': 0,
                });
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  // Future<String> uploadFile(File file, XFile fileWeb, Type xFile) async {
  //   Reference reference = storage.ref().child('movies/${DateTime.now()}.png');
  //   Uint8List imageTosave = await fileWeb.readAsBytes();
  //   SettableMetadata metaData = SettableMetadata(contentType: 'image/jpeg');
  //   UploadTask uploadTask = kIsWeb
  //       ? reference.putData(imageTosave, metaData)
  //       : reference.putFile(file);
  //   TaskSnapshot taskSnapshot = await uploadTask;
  //   return await taskSnapshot.ref.getDownloadURL();
  // }
}
