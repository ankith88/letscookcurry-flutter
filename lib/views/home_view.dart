import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letscookcurry/constants.dart';
import 'package:letscookcurry/views/category_view.dart';
import 'package:letscookcurry/views/dishes_view.dart';

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
                //IconButton
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () {
                    _signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                ), //IconButton
              ],
              leading: IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Menu Icon',
                onPressed: () {},
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
            body: SingleChildScrollView(
              reverse: false,
              dragStartBehavior: DragStartBehavior.down,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Text('Menu',
                            style: TextStyle(
                                color: kPrimaryTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        const Spacer(),
                        Text(
                            '${findFirstDateOfTheWeek()} to ${findLastDateOfTheWeek()}',
                            style: const TextStyle(
                                color: kPrimaryTextColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 10)),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    padding: const EdgeInsets.all(12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CategoryView(),
                      ],
                    ),
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.17,
                    padding: const EdgeInsets.all(12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [DishesView()],
                    ),
                  )
                ],
              ),
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
                          icon: Icons.search,
                          text: 'Search',
                        ),
                        GButton(
                          icon: Icons.person_rounded,
                          text: 'Profile',
                        ),
                      ],
                      // selectedIndex: _selectedIndex,
                      // onTabChange: (index) {
                      //   setState(() {
                      //     _selectedIndex = index;
                      //   });
                      // },
                    ),
                  ),
                )));
  }
}
