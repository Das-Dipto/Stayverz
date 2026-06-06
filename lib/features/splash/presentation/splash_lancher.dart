import 'package:flutter/material.dart';
import 'package:stayverz_flutter_app/features/splash/presentation/splash_screen.dart';

import '../../../main.dart';

class SplashLauncher extends StatelessWidget {
  final String initialRoute;
  final Uri? initialDeepLink; // ✅ Accept deep link URI

  const SplashLauncher({
    super.key,
    required this.initialRoute,
    this.initialDeepLink, // ✅ Optional, null if no deep link
  });

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      onFinish: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MyApp(
              initialRoute: initialRoute,
              initialDeepLink: initialDeepLink, // ✅ Pass it to MyApp
            ),
          ),
        );
      },
    );
  }
}

// Hello I am Tamim