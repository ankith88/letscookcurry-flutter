import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

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
      duration: 1000,
      splash: Image.asset(
        "assets/images/main_image-v2-2048.jpg",
        // height: (400 / 812.0) * MediaQuery.of(context).size.height,
        // width: (400 / 812.0) * MediaQuery.of(context).size.width,
      ),
      nextScreen: const LoginView(),
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}



// class HomePageView extends StatelessWidget {
//   const HomePageView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform,
//       ),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = FirebaseAuth.instance.currentUser;

//             // print(user);
//             if (user.isNull) {
//               return const LoginView();
//             } else {
//               print(user);
//               if (user!.emailVerified) {
//                 return const HomeView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             }

//           case ConnectionState.none:
//             return const LoginView();
//           default:
//             return const Text('Loading...');
//         }
//       },
//     );
//   }
// }
