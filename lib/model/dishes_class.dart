import 'package:cloud_firestore/cloud_firestore.dart';

class DishesClass {
  final String collectionid;
  final String image;
  final String name;
  final String description;
  final String course;
  final String servings;
  final double price;
  final DocumentReference<Map<String, dynamic>> category;

  DishesClass(
      {required this.collectionid,
      required this.image,
      required this.name,
      required this.description,
      required this.course,
      required this.servings,
      required this.price,
      required this.category});
}
