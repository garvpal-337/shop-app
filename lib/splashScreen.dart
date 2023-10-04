import 'package:flutter/material.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/png/campus_logo.webp',fit: BoxFit.cover,),
      ),
    );
  }
}
