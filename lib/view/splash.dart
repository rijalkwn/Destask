import 'dart:async';

import 'package:destask/view/Menu/bottom_nav.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const BottomNav()));
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Image.asset(
            'assets/img/logo.png',
          ),
        ),
      ),
    );
  }
}
