import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letscookcurry/constants.dart';

import '../components/dish_card.dart';
import 'cart_class.dart';
import 'dishes_class.dart';

class CustomSearch extends SearchDelegate {
  List<DishesClass> allDishes = [];
  List<CartClass> cartItems = [];
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  late User _currentUser = _auth.currentUser!;
  int cartQty = 0;
  final Function updateCartQty;

  CustomSearch(this.allDishes, this.cartItems, this.updateCartQty);

  void updateCart() {
    this.updateCartQty(cartQty);
  }

  Future<void> _getDishesAndCartItems() async {
    var dishesData =
        await FirebaseFirestore.instance.collection('recipes').get();

    List<DishesClass> tempDishToBeStored = [];

    for (var result in dishesData.docs) {
      var dishName = result.data()['name'];
      var dishDescription = result.data()['description'];
      var dishServings = result.data()['servings'];
      var dishCourse = result.data()['course'];
      var dishImage = result.data()['image'];
      var dishCategory = result.data()['category'];
      var dishPrice = result.data()['price'];
      var available = result.data()['available'];

      if (available == true) {
        final newDish = DishesClass(
            image: dishImage,
            name: dishName,
            description: dishDescription,
            course: dishCourse,
            servings: dishServings.toString(),
            price: dishPrice,
            category: dishCategory,
            collectionid: result.id);
        tempDishToBeStored.add(newDish);
      }
    }

    var collectionCart = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .collection('cart_items')
        .get();

    List<CartClass> tempCartItemsToBeStored = [];

    for (var result in collectionCart.docs) {
      var itemQty = result.data()['item_qty'];
      var itemCollectionId = result.data()['recipes_collection_id'];

      var recipeData = await FirebaseFirestore.instance
          .collection("recipes")
          .doc(itemCollectionId)
          .get();

      final newDish = DishesClass(
          image: recipeData.data()!['image'],
          name: recipeData.data()!['name'],
          description: recipeData.data()!['description'],
          course: recipeData.data()!['course'],
          servings: recipeData.data()!['servings'].toString(),
          price: recipeData.data()!['price'],
          category: recipeData.data()!['category'],
          collectionid: itemCollectionId);
      final cartItem = CartClass(
          dish: newDish, qty: itemQty, recipeCollectionId: itemCollectionId);
      tempCartItemsToBeStored.add(cartItem);
    }

    // setState(() {
    allDishes.addAll(tempDishToBeStored);
    cartItems.addAll(tempCartItemsToBeStored);
    // });
  }

  Future<void> _addItemsToCart(DishesClass items, int qty) async {
    // _currentUser = _auth.currentUser!;

    firestoreInstance
        .collection("users")
        .doc(_currentUser.uid)
        .collection("cart_items")
        .where("recipes_collection_id", isEqualTo: items.collectionid)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          firestoreInstance
              .collection("users")
              .doc(_currentUser.uid)
              .collection("cart_items")
              .add({
            "recipes_collection_id": items.collectionid,
            "item_qty": qty
          }).then((value) {
            final cartItem = CartClass(
                dish: items, qty: qty, recipeCollectionId: items.collectionid);
            // setState(() {
            cartItems.add(cartItem);
            cartQty = cartItems.length;
            updateCart();
            // submitTx();
            // });
          });
        } else {
          for (var docSnapshot in querySnapshot.docs) {
            firestoreInstance
                .collection("users")
                .doc(_currentUser.uid)
                .collection("cart_items")
                .doc(docSnapshot.id)
                .update({"item_qty": qty});
            final cartItem = CartClass(
                dish: items, qty: qty, recipeCollectionId: docSnapshot.id);
            // setState(() {
            cartItems.add(cartItem);
            // });
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    // print(exitingCartItemUpdate);
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
    for (var dish in allDishes) {
      if (dish.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(dish);
      }
    }

    // _getDishesAndCartItems();

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
                int dishCartQty = 0;
                for (var x = 0; x < cartItems.length; x++) {
                  if (matchQuery[index].collectionid ==
                      cartItems[x].recipeCollectionId) {
                    dishCartQty = cartItems[x].qty;
                  }
                }
                return DishCard(
                    matchQuery[index], _addItemsToCart, dishCartQty);
              }),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<DishesClass> matchQuery = [];

    for (var dish in allDishes) {
      if (dish.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(dish);
      }
    }

    // _getDishesAndCartItems();

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
                int dishCartQty = 0;
                for (var x = 0; x < cartItems.length; x++) {
                  if (matchQuery[index].collectionid ==
                      cartItems[x].recipeCollectionId) {
                    dishCartQty = cartItems[x].qty;
                  }
                }
                return DishCard(
                    matchQuery[index], _addItemsToCart, dishCartQty);
              }),
        ),
      ),
    );
  }
}
