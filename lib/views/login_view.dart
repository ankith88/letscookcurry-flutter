import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/form_error.dart';
import '../constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  void _addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
    print(errors);
  }

  void _removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<void> _loginUser(BuildContext context) async {
    final enteredEmail = _email.text;
    final enteredPassword = _password.text;

    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      _addError(error: kEmailNullError);
      _addError(error: kPassNullError);
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: enteredEmail, password: enteredPassword);
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return print('Email already in use');
        case 'invalid-email':
          return print('Invalid Email');
      }
    }
    // Navigator.pushNamed(context, LandingScreen.routeName);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                padding: const EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Image.asset(
                    "assets/images/lcc_logo.png",
                    height: (200 / 812.0) * MediaQuery.of(context).size.height,
                    width: (200 / 812.0) * MediaQuery.of(context).size.width,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _email,
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
                            hintText: "Enter your email",
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
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 10),
                        child: TextFormField(
                          controller: _password,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return kPassNullError;
                            } else if (value.length < 8) {
                              return kShortPassError;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _removeError(error: kPassNullError);
                            } else if (emailValidatorRegExp.hasMatch(value)) {
                              _removeError(error: kMatchPassError);
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            // labelText: "Email",
                            labelStyle: const TextStyle(color: Colors.black),
                            hintText: "Enter your email",
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
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20, bottom: 10),
                          child: FormError(errors: errors)),
                      Container(
                        padding: EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 15),
                        child: SizedBox(
                          width: double.infinity,
                          height:
                              (50 / 812.0) * MediaQuery.of(context).size.height,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              primary: Colors.white,
                              elevation: 6,
                              animationDuration: Duration(seconds: 5),
                              backgroundColor: kPrimaryColor,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/home', (route) => false);
                                } on FirebaseAuthException catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                          title: const Text('Invalid Login'),
                                          content: Text('${e.message}')));
                                }
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: (20 / 812.0) *
                                    MediaQuery.of(context).size.height,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 15),
                        child: SizedBox(
                          width: double.infinity,
                          height:
                              (50 / 812.0) * MediaQuery.of(context).size.height,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              primary: kPrimaryTextColor,
                              elevation: 6,
                              animationDuration: const Duration(seconds: 5),
                              backgroundColor: kSecondaryButtonColor,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/register', (route) => false);
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: (15 / 812.0) *
                                    MediaQuery.of(context).size.height,
                                // fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]))),
      ),
    );
  }
}
