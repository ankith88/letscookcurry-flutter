import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letscookcurry/constants.dart';
import 'package:letscookcurry/views/category_view.dart';
import 'package:letscookcurry/views/dishes_view.dart';
import 'package:letscookcurry/views/favourite_view.dart';
import 'package:letscookcurry/views/menu_view.dart';
import 'package:letscookcurry/views/profile_view.dart';

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

  bool _progressController = true;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MenuView(),
    FavouriteView(),
    ProfileView(),
  ];

  @override
  void initState() {
    _currentUser = _auth.currentUser!;
    print(_currentUser.uid);
    _getUserDetails();

    super.initState();
  }

  Future<void> _getUserDetails() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(_currentUser.uid).get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      print(data);
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
        print(userInitials);
        _progressController = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
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
              title: const Text("Let Cook Curry"),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.shopping_cart_rounded),
                  tooltip: 'Logout',
                  onPressed: () {
                    // _signOut();
                    // Navigator.of(context)
                    //     .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                ), //IconButton
              ],
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 10,
                  child: Text(
                    userInitials,
                    style: TextStyle(
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
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex)
            ),
            bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(.1),
                    )
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: GNav(
                      rippleColor: Colors.grey[300]!,
                      hoverColor: Colors.grey[100]!,
                      gap: 8,
                      activeColor: kSecondaryButtonColor,
                      iconSize: 24,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: Colors.grey[100]!,
                      color: kPrimaryColor,
                      tabs: const [
                        GButton(
                          icon: Icons.home,
                          text: 'Home',
                        ),
                        GButton(
                          icon: Icons.favorite,
                          text: 'Likes',
                        ),
                        GButton(
                          icon: Icons.person_rounded,
                          text: 'Profile',
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
