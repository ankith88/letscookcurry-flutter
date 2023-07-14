import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letscookcurry/constants.dart';
import 'package:letscookcurry/views/menu_view.dart';
import 'package:letscookcurry/views/profile_view.dart';
import 'package:letscookcurry/views/cart_view.dart';
import 'package:badges/badges.dart' as badges;

import '../model/cart_class.dart';
import '../model/custom_search.dart';
import '../model/dishes_class.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late User _currentUser;
  late GoogleSignInAccount googleUser;
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  var userFirstName = "";
  var userLastName = "";
  var userEmail = "";

  var userInitials = "";

  int cartItemsLength = 0;

  List<DishesClass> allDishes = [];
  List<CartClass> cartItems = [];

  bool _progressController = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    _currentUser = _auth.currentUser!;
    _getUserDetails();
    _getDishesAndCartItems();

    super.initState();
  }

  Future<void> _getUserDetails() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(_currentUser.uid).get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      userFirstName = data?['firstname'];
      userLastName = data?['lastname'];
      userEmail = data?['email'];

      var userFirstNameInitial = userFirstName[0];
      var userLastNameInitial = "";
      if (userLastName.isNotEmpty) {
        userLastNameInitial = userLastName[0];
      }

      setState(() {
        userInitials = userFirstNameInitial.toUpperCase() +
            userLastNameInitial.toUpperCase();
        _progressController = false;
      });
    }
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
      cartItemsLength = cartItems.length;
    });
  }

  void updateCartQuantity(int qty) {
    setState(() {
      cartItemsLength = qty;
    });
  }

// Gets the starting date of the current week
  String findFirstDateOfTheWeek() {
    DateTime now = DateTime.now();
    DateTime firstDateCurrentWeek =
        now.subtract(Duration(days: now.weekday - 1));

    return "${firstDateCurrentWeek.day.toString().padLeft(2, '0')}/${firstDateCurrentWeek.month.toString().padLeft(2, '0')}/${firstDateCurrentWeek.year.toString()}";
  }

//Gets the last date of the current week
  String findLastDateOfTheWeek() {
    DateTime now = DateTime.now();
    DateTime lastDateCurrentWeek =
        now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    return "${lastDateCurrentWeek.day.toString().padLeft(2, '0')}/${lastDateCurrentWeek.month.toString().padLeft(2, '0')}/${lastDateCurrentWeek.year.toString()}";
  }

  StatefulWidget viewDisplay(int index) {
    switch (index) {
      case 0:
        return MenuView(updateCartQuantity);
      case 1:
        return CartView(cartItemsLength, updateCartQuantity);
      case 2:
        return ProfileView();
      default:
        return MenuView(updateCartQuantity);
    }
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
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text(
                "Let's Cook Curry",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: CustomSearch(allDishes));
                    },
                    icon: const Icon(Icons.search_rounded)),
              ],
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 10,
                  child: Text(
                    userInitials,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: kSecondaryButtonColor),
                  ),
                ),
              ), //
              titleSpacing: 00.0,
              centerTitle: true,
              toolbarHeight: 60.2,
              toolbarOpacity: 0.8,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25)),
              ),
              elevation: 0.00,
              backgroundColor: kPrimaryColor,
            ),
            body: Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bgimg.png"),
                      fit: BoxFit.fitHeight)),
              child: SingleChildScrollView(
                  child: Center(
                child: viewDisplay(_selectedIndex),
              )),
            ),
            bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: kSecondaryColor,
                    )
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8),
                    child: GNav(
                      rippleColor: kPrimaryColor,
                      hoverColor: kPrimaryColor,
                      gap: 8,
                      activeColor: kSecondaryButtonColor,
                      iconSize: 24,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: kPrimaryColor,
                      color: kSecondaryButtonColor,
                      tabs: [
                        const GButton(
                          icon: Icons.home,
                          text: 'Home',
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kSecondaryButtonColor),
                        ),
                        GButton(
                          leading: badges.Badge(
                            badgeStyle: const badges.BadgeStyle(
                                badgeColor: Colors.white,
                                padding: EdgeInsets.all(5)),
                            badgeContent: Text(
                              '${cartItemsLength}',
                              style: const TextStyle(
                                  color: kSecondaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_rounded,
                              color: kSecondaryButtonColor,
                            ),
                          ),
                          icon: Icons.shopping_cart_rounded,
                          gap: 25,
                          text: 'Cart',
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kSecondaryButtonColor),
                        ),
                        const GButton(
                          icon: Icons.person_rounded,
                          text: 'Profile',
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kSecondaryButtonColor),
                        ),
                      ],
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                )));
  }
}
