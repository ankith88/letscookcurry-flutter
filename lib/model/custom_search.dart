import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letscookcurry/constants.dart';

import '../components/dish_card.dart';
import 'cart_class.dart';
import 'dishes_class.dart';

class CustomSearch extends SearchDelegate {
  List<DishesClass> allDishesSearch = [];
  List<CartClass> cartItems = [];
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  late User _currentUser;

  CustomSearch(this.allDishesSearch);

  void _addItemsToCart(DishesClass items, int qty) {
    _currentUser = _auth.currentUser!;
    firestoreInstance
        .collection("users")
        .doc(_currentUser.uid)
        .collection("cart_items")
        .add({
      "recipes_collection_id": items.collectionid,
      "item_qty": qty
    }).then((value) {
      final cartItem = CartClass(dish: items, qty: qty);
      cartItems.add(cartItem);
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(
            Icons.clear_rounded,
            color: kSecondaryButtonColor,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: kSecondaryButtonColor,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<DishesClass> matchQuery = [];
    for (var dish in allDishesSearch) {
      if (dish.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(dish);
      }
    }

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bgimg.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: matchQuery.length,
              itemBuilder: (context, index) {
                // return Text("$index");
                return DishCard(matchQuery[index], _addItemsToCart);
              }),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<DishesClass> matchQuery = [];

    for (var dish in allDishesSearch) {
      if (dish.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(dish);
      }
    }

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bgimg.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: matchQuery.length,
              itemBuilder: (context, index) {
                // return Text("$index");
                return DishCard(matchQuery[index], _addItemsToCart);
              }),
        ),
      ),
    );
  }
}
