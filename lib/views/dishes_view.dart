//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letscookcurry/components/dish_card.dart';
import 'package:letscookcurry/model/cart_class.dart';
import 'package:letscookcurry/model/dishes_class.dart';

class DishesView extends StatefulWidget {
  const DishesView({super.key});

  @override
  State<DishesView> createState() => _DishesViewState();
}

class _DishesViewState extends State<DishesView> {
  List<DishesClass> allDishes = [];
  List<CartClass> cartItems = [];
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = _auth.currentUser!;
    getDishes();

    super.initState();
  }

  Future<void> _getCartItems() async {
    var collectionCart = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .collection('cart_items')
        .get();

    for (var result in collectionCart.docs) {
      var itemQty = result.data()['item_qty'];
      var itemCollectionId = result.data()['recipes_collection_id'];
    }
  }

  Future<void> getDishes() async {
    var dishesData =
        await FirebaseFirestore.instance.collection('recipes').get();

    for (var result in dishesData.docs) {
      var dishName = result.data()['name'];
      var dishDescription = result.data()['description'];
      var dishServings = result.data()['servings'];
      var dishCourse = result.data()['course'];
      var dishImage = result.data()['image'];
      var dishCategory = result.data()['category'];
      var dishPrice = result.data()['price'];

      final newDish = DishesClass(
          image: dishImage,
          name: dishName,
          description: dishDescription,
          course: dishCourse,
          servings: dishServings.toString(),
          price: dishPrice,
          category: dishCategory,
          collectionid: result.id);
      setState(() {
        allDishes.add(newDish);
      });
    }
  }

  Future<void> _addItemsToCart(DishesClass items, int qty) async {
    print('Dish added to cart name: ');
    print(items.name);

    print('Qty of Dish added to cart: ');
    print(qty);

    var exitingCartItemUpdate = firestoreInstance
        .collection("users")
        .doc(_currentUser.uid)
        .collection("cart_items")
        .where("recipes_collection_id", isEqualTo: items.collectionid)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.length == 0) {
          firestoreInstance
              .collection("users")
              .doc(_currentUser.uid)
              .collection("cart_items")
              .add({
            "recipes_collection_id": items.collectionid,
            "item_qty": qty
          }).then((value) {
            final cartItem = CartClass(dish: items, qty: qty);
            setState(() {
              cartItems.add(cartItem);
            });
          });
        } else {
          for (var docSnapshot in querySnapshot.docs) {
            print('${docSnapshot.id} => ${docSnapshot.data()}');
            firestoreInstance
                .collection("users")
                .doc(_currentUser.uid)
                .collection("cart_items")
                .doc(docSnapshot.id)
                .update({"item_qty": qty});
            final cartItem = CartClass(dish: items, qty: qty);
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
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allDishes.length,
          itemBuilder: (context, index) {
            // return Text("$index");
            return DishCard(allDishes[index], _addItemsToCart);
          }),
    );
  }
}
