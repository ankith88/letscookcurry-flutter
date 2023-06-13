import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import 'login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: Image.asset(
        "assets/images/lcc_logo.png",
        // height: (400 / 812.0) * MediaQuery.of(context).size.height,
        // width: (400 / 812.0) * MediaQuery.of(context).size.width,
      ),
      nextScreen: const HomePageView(),
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            print(user);
            // print(user);
            // if (user!.emailVerified) {
            // } else {
            //   return VerifyEmailView();
            // }
            return const LoginView();
          default:
            return const Text('Loading...');
        }
      },
    );
  }
}
