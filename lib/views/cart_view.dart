import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

import '../constants.dart';
import '../model/cart_class.dart';
import '../model/dishes_class.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<CartClass> cartItems = [];
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  late User _currentUser;
  int dishQty = 0;
  int simpleIntInput = 1;

  @override
  void initState() {
    _currentUser = _auth.currentUser!;
    _getCartItems();

    super.initState();
  }

  Future<void> _getCartItems() async {
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
      cartItems.addAll(tempCartItemsToBeStored);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                          color: kSecondaryButtonColor, width: 0)),
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                          ),
                          child: Image.asset(
                            cartItems[index].dish.image,
                            height: MediaQuery.of(context).size.height * 0.075,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              cartItems[index].dish.name,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      (15 / 812.0),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${cartItems[index].dish.price}',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      (14 / 812.0),
                                  color: kPrimaryTextColor),
                            ),
                          ],
                        ),
                      ),
                      InputQty(
                          maxVal: 5,
                          initVal: cartItems[index].qty,
                          steps: 1,
                          minVal: 1,
                          showMessageLimit: false,
                          borderShape: BorderShapeBtn.circle,
                          boxDecoration: const BoxDecoration(),
                          minusBtn: const Icon(Icons.remove, size: 14),
                          plusBtn: const Icon(
                            Icons.add,
                            size: 14,
                          ),
                          btnColor1: kSecondaryButtonColor,
                          btnColor2: kSecondaryButtonColor,
                          textFieldDecoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15)),
                          onQtyChanged: (val) {
                            // if (kDebugMode) {
                            // print(val);
                            // setState(() {
                            dishQty = val as int;
                            // });
                          }
                          // },
                          ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
