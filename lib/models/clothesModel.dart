// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';


class Clothe {
  String? cID, cName, cUrlImg, cUserID, cUserName, cCategories, cPoster;
  Timestamp? cTimestamp;
  bool? isMyFavoritedCar;
  int? cFavoriteCount;
  Clothe(
      {this.cID,
      this.cName,
      this.cUrlImg,
      this.cUserID,
      this.cUserName,
      this.cTimestamp,
      this.cCategories,
      this.cPoster,
      this.isMyFavoritedCar,
      this.cFavoriteCount});
}

// class Product {
//   final String? image, title;
//   String description;
//   final int? price, size, id;
//   final Color? color;
//   Product({
//     this.id,
//     this.image,
//     this.title,
//     this.price,
//     required this.description,
//     this.size,
//     this.color,
//   });
// }

// List<Product> products = [
//   Product(
//       id: 1,
//       title: "Office Code",
//       price: 234,
//       size: 12,
//       description: dummyText,
//       image: "assets/images/bag_1.png",
//       color: const Color(0xFF3D82AE)),
//   Product(
//       id: 2,
//       title: "Belt Bag",
//       price: 234,
//       size: 8,
//       description: dummyText,
//       image: "assets/images/bag_2.png",
//       color: const Color(0xFFD3A984)),
//   Product(
//       id: 3,
//       title: "Hang Top",
//       price: 234,
//       size: 10,
//       description: dummyText,
//       image: "assets/images/bag_3.png",
//       color: const Color(0xFF989493)),
//   Product(
//       id: 4,
//       title: "Old Fashion",
//       price: 234,
//       size: 11,
//       description: dummyText,
//       image: "assets/images/bag_4.png",
//       color: const Color(0xFFE6B398)),
//   Product(
//       id: 5,
//       title: "Office Code",
//       price: 234,
//       size: 12,
//       description: dummyText,
//       image: "assets/images/bag_5.png",
//       color: const Color(0xFFFB7883)),
//   Product(
//     id: 6,
//     title: "Office Code",
//     price: 234,
//     size: 12,
//     description: dummyText,
//     image: "assets/images/bag_6.png",
//     color: const Color(0xFFAEAEAE),
//   ),
// ];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
