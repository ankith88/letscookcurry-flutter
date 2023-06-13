import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letscookcurry/constants.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  final Map<String, String> _authData = {
    'firstname': '',
    'lastname': '',
    'phone': '',
    'email': '',
    'password': '',
  };

  String? validateFirstName(String value) {
    if (value.isEmpty) {
      return 'Please enter First Name';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: kPrimaryColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Register',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  icon: const Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.white,
                    semanticLabel: 'Back',
                  )),
            ],
          ),
        ),
        body: SingleChildScrollView(
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
                          _authData['firstname'] = value!;
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
                          _authData['lastname'] = value!;
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
                          _authData['email'] = value!;
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
                          _authData['email'] = value!;
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
                        controller: passwordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kPassNullError;
                          } else if (value.length < 8) {
                            return kShortPassError;
                          }
                        },
                        decoration: InputDecoration(
                          // labelText: "Email",
                          labelStyle: const TextStyle(color: kHintTextColor),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: kHintTextColor),
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: IconButton(
                              onPressed: () {},
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(20),
                              icon: const Icon(
                                Icons.lock,
                                color: kPrimaryColor,
                                size: 22,
                              )),
                        ),
                        style: const TextStyle(
                          color: kPrimaryTextColor,
                        ),
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 15),
                  child: SizedBox(
                    width: double.infinity,
                    height: (50 / 812.0) * MediaQuery.of(context).size.height,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        primary: Colors.white,
                        elevation: 6,
                        animationDuration: const Duration(seconds: 5),
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          // _loginUser(context);
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize:
                              (18 / 812.0) * MediaQuery.of(context).size.height,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final email = emailController.text;
                    final password = passwordController.text;

                    try {
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);
                      print(userCredential);
                    } on FirebaseAuthException catch (e) {
                      switch (e.code) {
                        case 'email-already-in-use':
                          return print('Email already in use');
                        case 'invalid-email':
                          return print('Invalid Email');
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    child: const Text('Login'))
              ],
            ),
          ),
        )));
  }
}
