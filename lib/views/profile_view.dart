import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late User _currentUser;
  late GoogleSignInAccount googleUser;
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var userFirstName = "";
  var userLastName = "";
  var userEmail = "";
  var userMobile = "";

  var userInitials = "";

  @override
  void initState() {
    _currentUser = _auth.currentUser!;
    _getUserDetails();
    super.initState();
  }

  Future<void> _getUserDetails() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(_currentUser.uid).get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      userFirstName = data?['firstname'];
      userLastName = data?['lastname'];

      var userFirstNameInitial = userFirstName[0];
      var userLastNameInitial = "";
      if (userLastName.isNotEmpty) {
        userLastNameInitial = userLastName[0];
      }

      setState(() {
        userInitials = userFirstNameInitial.toUpperCase() +
            userLastNameInitial.toUpperCase();
        userFirstName = data?['firstname'];
        firstNameController.text = data?['firstname'];
        userLastName = data?['lastname'];
        lastNameController.text = data?['lastname'];
        userEmail = data?['email'];
        emailController.text = data?['email'];
        userMobile = data?['mobile'];
        mobileNumberController.text = data?['mobile'];
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      height: MediaQuery.of(context).size.height * 1,
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Image.asset(
              "assets/images/lcc_logo.png",
              height: (150 / 812.0) * MediaQuery.of(context).size.height,
              width: (150 / 812.0) * MediaQuery.of(context).size.width,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Column(
                children: [
                  TextFormField(
                    controller: firstNameController,
                    enabled: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your First Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      // labelText: "Email",
                      labelStyle: const TextStyle(color: kHintTextColor),
                      hintText: "First Name",
                      hintStyle: const TextStyle(color: kHintTextColor),
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: IconButton(
                          onPressed: () {},
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(20),
                          icon: const Icon(
                            Icons.person,
                            color: kPrimaryColor,
                            size: 22,
                          )),
                    ),
                    style: const TextStyle(
                      color: kPrimaryTextColor,
                    ),
                    onSaved: (value) {
                      // _authData['firstname'] = value!;
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Column(
                children: [
                  TextFormField(
                    enabled: false,
                    controller: lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Last Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      // labelText: "Email",
                      labelStyle: const TextStyle(color: kHintTextColor),
                      hintText: "Last Name",
                      hintStyle: const TextStyle(color: kHintTextColor),
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: IconButton(
                          onPressed: () {},
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(20),
                          icon: const Icon(
                            Icons.person,
                            color: kPrimaryColor,
                            size: 22,
                          )),
                    ),
                    style: const TextStyle(
                      color: kPrimaryTextColor,
                    ),
                    onSaved: (value) {
                      // _authData['lastname'] = value!;
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Column(
                children: [
                  TextFormField(
                    controller: mobileNumberController,
                    enabled: false,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return kPhoneNumberNullError;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      // labelText: "Email",
                      labelStyle: const TextStyle(color: kHintTextColor),
                      hintText: "Mobile Number",
                      hintStyle: const TextStyle(color: kHintTextColor),
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: IconButton(
                          onPressed: () {},
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(20),
                          icon: const Icon(
                            Icons.phone,
                            color: kPrimaryColor,
                            size: 22,
                          )),
                    ),
                    style: const TextStyle(
                      color: kPrimaryTextColor,
                    ),
                    onSaved: (value) {
                      // _authData['email'] = value!;
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return kEmailNullError;
                      } else if (!emailValidatorRegExp.hasMatch(value)) {
                        return kInvalidEmailError;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      // labelText: "Email",
                      labelStyle: const TextStyle(color: kHintTextColor),
                      hintText: "Email",
                      hintStyle: const TextStyle(color: kHintTextColor),
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: IconButton(
                          onPressed: () {},
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(20),
                          icon: const Icon(
                            Icons.email,
                            color: kPrimaryColor,
                            size: 22,
                          )),
                    ),
                    style: const TextStyle(
                      color: kPrimaryTextColor,
                    ),
                    onSaved: (value) {
                      // _authData['email'] = value!;
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
              child: SizedBox(
                  width: double.infinity,
                  height: (40 / 812.0) * MediaQuery.of(context).size.height,
                  child: ElevatedButton(
                    onPressed: () {
                      _signOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      primary: Colors.white,
                      elevation: 6,
                      animationDuration: Duration(seconds: 5),
                      backgroundColor: kSecondaryButtonColor,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: (18 / 812.0) *
                                  MediaQuery.of(context).size.height,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}
