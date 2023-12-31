//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letscookcurry/components/dish_card.dart';
import 'package:letscookcurry/model/cart_class.dart';
import 'package:letscookcurry/model/dishes_class.dart';

class DishesView extends StatefulWidget {
  final Function updateCartQty;

  DishesView(this.updateCartQty);
  // const DishesView({super.key});

  @override
  State<DishesView> createState() => _DishesViewState();
}

class _DishesViewState extends State<DishesView> {
  List<DishesClass> allDishes = [];
  List<CartClass> cartItems = [];
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  late User _currentUser;
  int cartQty = 0;

  @override
  void initState() {
    _currentUser = _auth.currentUser!;
    _getDishesAndCartItems();

    super.initState();
  }

  void submitTx() {
    widget.updateCartQty(cartQty); // Close the modal
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

    setState(() {
      allDishes.addAll(tempDishToBeStored);
      cartItems.addAll(tempCartItemsToBeStored);
    });
  }

  Future<void> _addItemsToCart(DishesClass items, int qty) async {
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
            setState(() {
              cartItems.add(cartItem);
              cartQty = cartItems.length;
              submitTx();
            });
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
            setState(() {
              cartItems.add(cartItem);
            });
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    // print(exitingCartItemUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          allDishes = [];
          cartItems = [];
          _getDishesAndCartItems();
        });
        
      },
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allDishes.length,
          // physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            int dishCartQty = 0;
            for (var x = 0; x < cartItems.length; x++) {
              if (allDishes[index].collectionid ==
                  cartItems[x].recipeCollectionId) {
                dishCartQty = cartItems[x].qty;
              }
            }
            return DishCard(allDishes[index], _addItemsToCart, dishCartQty);
          }),
    ));
  }
}
