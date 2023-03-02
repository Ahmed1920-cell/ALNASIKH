import 'package:flutter/material.dart';

import 'main.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  void initState(){
    super.initState();
    _navigateToHome();
  }

  _navigateToHome()async{
    await Future.delayed(Duration(milliseconds: 5510), (){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage("192.168.1.1")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Container(
          child: Text('HELLOLLLLLLL asasa',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}

