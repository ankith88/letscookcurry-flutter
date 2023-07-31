import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:letscookcurry/components/cart_card.dart';
import '../constants.dart';
import '../model/cart_class.dart';
import '../model/dishes_class.dart';

class CartView extends StatefulWidget {
  int cartItemLength;
  final Function updateCartQty;

  CartView(this.cartItemLength, this.updateCartQty);

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
  bool _progressController = true;

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
      _progressController = false;
    });
  }

  Future<void> _updateCartItemQuantity(
      CartClass currentCartItem, int qty) async {
    firestoreInstance
        .collection("users")
        .doc(_currentUser.uid)
        .collection("cart_items")
        .where("recipes_collection_id",
            isEqualTo: currentCartItem.recipeCollectionId)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          firestoreInstance
              .collection("users")
              .doc(_currentUser.uid)
              .collection("cart_items")
              .add({
            "recipes_collection_id": currentCartItem.recipeCollectionId,
            "item_qty": qty
          }).then((value) {
            final cartItem = CartClass(
                dish: currentCartItem.dish,
                qty: qty,
                recipeCollectionId: currentCartItem.recipeCollectionId);
            setState(() {
              cartItems.add(cartItem);
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
            // final cartItem = CartClass(
            //     dish: currentCartItem.dish,
            //     qty: qty,
            //     recipeCollectionId: docSnapshot.id);
            setState(() {
              for (var x = 0; x < cartItems.length; x++) {
                if (cartItems[x].recipeCollectionId == docSnapshot.id) {
                  cartItems[x].qty = qty;
                }
              }
              // cartItems.add(cartItem);
            });
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    // print(exitingCartItemUpdate);
  }

  Future<void> sendEmail() async {
    final Email email = Email(
      body: 'Test',
      subject: 'Test Subject',
      recipients: ['ankith88@gmail.com'],
      isHTML: true,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  void _deleteCartItem(CartClass currentCartItem) {
    firestoreInstance
        .collection("users")
        .doc(_currentUser.uid)
        .collection("cart_items")
        .where("recipes_collection_id",
            isEqualTo: currentCartItem.recipeCollectionId)
        .get()
        .then((res) {
      res.docs.forEach((result) {
        print(result.data());
        print(result.id);
        // var incrementedCount =
        firestoreInstance
            .collection("users")
            .doc(_currentUser.uid)
            .collection("cart_items")
            .doc(result.id)
            .delete();
      });
    });
    setState(() {
      for (var x = 0; x < cartItems.length; x++) {
        if (cartItems[x].recipeCollectionId ==
            currentCartItem.recipeCollectionId) {
          cartItems.removeAt(x);
        }
      }
      widget.cartItemLength = cartItems.length;
      updateCart();
    });
  }

  void updateCart() {
    widget.updateCartQty(widget.cartItemLength);
  }

  @override
  Widget build(BuildContext context) {
    return _progressController
        ? const Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                CircularProgressIndicator(color: kPrimaryColor)
              ]))
        : cartItems.length == 0
            ? Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cart is Empty',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.height * (16 / 812.0)),
                  ),
                ],
              )
            : Column(
                children: [
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return CartCard(cartItems[index],
                            _updateCartItemQuantity, _deleteCartItem);
                      }),
                  ElevatedButton(
                      onPressed: () {
                        // submitTx();
                        sendEmail();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        animationDuration: const Duration(seconds: 5),
                      ),
                      child: Text(
                        'PLACE ORDER',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height *
                                (16 / 812.0)),
                      ))
                ],
              );
  }
}
