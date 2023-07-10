import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/category_card.dart';
import '../model/category_class.dart';
import '../model/dishes_class.dart';

class CategoryView extends StatefulWidget {
  // static const double _cardWidth = 115;

  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  // const CategoryView({super.key});
  double defaultRadius = 8.0;

  List<CategoryClass> allCategory = [];
  List<String> allCategoriesIds = [];

  // final CollectionReference _collectionRef =
  //     FirebaseFirestore.instance.collection('category');

  @override
  void initState() {
    getDishes();

    super.initState();
  }

  Future<void> getDishes() async {
    var dishesData =
        await FirebaseFirestore.instance.collection('recipes').get();

    dishesData.docs.forEach((result) async {
      var dishName = result.data()['name'];
      var dishDescription = result.data()['description'];
      var dishServings = result.data()['servings'];
      var dishCourse = result.data()['course'];
      var dishImage = result.data()['image'];
      var dishCategory = result.data()['category'];
      var dishPrice = result.data()['price'];

      var categoryArray = dishCategory.toString().split('/');
      var categoryArray2 = categoryArray[1].toString().split(')');

      allCategoriesIds.add(categoryArray2[0]);
    });
    allCategoriesIds = allCategoriesIds.toSet().toList();
    for (var x = 0; x < allCategoriesIds.length; x++) {
      var collection = FirebaseFirestore.instance.collection('category');

      var docSnapshot = await collection.doc(allCategoriesIds[x]).get();
      Map<String, dynamic>? data = docSnapshot.data();

      final cat = CategoryClass(name: data?['name']);

      setState(() {
        allCategory.add(cat);
      });
    }
  }

  // final newDish = DishesClass(
  //     image: dishImage,
  //     name: dishName,
  //     description: dishDescription,
  //     course: dishCourse,
  //     servings: dishServings.toString(),
  //     price: dishPrice,
  //     category: dishCategory);
  // print(newDish.toString());
  // setState(() {
  //   allDishes.add(newDish);
  // });

  Future<void> getCategory() async {
    var categoryData =
        await FirebaseFirestore.instance.collection('category').get();

    setState(() {
      allCategory = List.from(categoryData.docs.map((doc) => CategoryClass(
            name: doc["name"],
          )));
    });
    // // Get docs from collection reference
    // QuerySnapshot querySnapshot = await _collectionRef.get();
    // // Get data from docs and convert map to List
    // allCategory = querySnapshot.docs
    //     .map((doc) => CategoryClass(
    //           name: doc["name"],
    //         ))
    //     .toList();
    print(allCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: allCategory.length,
            itemBuilder: (context, index) {
              // return Text("$index");
              return CategoryCard(allCategory[index] as CategoryClass);
            }),
      ),
    );
  }
}
