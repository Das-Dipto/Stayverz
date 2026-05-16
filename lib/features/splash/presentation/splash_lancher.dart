import 'package:flutter/material.dart';
import 'package:stayverz_flutter_app/features/splash/presentation/splash_screen.dart';

import '../../../main.dart';
class SplashLauncher extends StatelessWidget {
  final String initialRoute;
  const SplashLauncher({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      onFinish: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MyApp(initialRoute: initialRoute),
          ),
        );
      },
    );
  }
}

// Hello I am Tamim