import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'main.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: AnimatedSplashScreen(
            duration: 3000,
            splash: Image.asset('assets/ic_launcher.png'),
            nextScreen: MyHomePage("192.168.1.1"),
            splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: PageTransitionType.scale,
            backgroundColor: Color.fromRGBO(96, 125, 139, 1)));
  }
}
