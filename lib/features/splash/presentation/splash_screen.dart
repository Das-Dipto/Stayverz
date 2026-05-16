
import 'package:flutter/material.dart';
import 'dart:async';

import '../../../core/constants/app_routes.dart';
import '../../../main.dart';
class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  const SplashScreen({super.key, this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Fade in
    Future.delayed(Duration.zero, () {
      setState(() => _opacity = 1.0);
    });

    // Navigate after 3 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      widget.onFinish?.call();
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 800),
        child: SizedBox.expand(
          child: Image.asset(
            'assets/splash_screen.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}



// Hello I am Tamim