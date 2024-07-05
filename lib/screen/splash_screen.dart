import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_locker/screen/homepage_screen.dart';
import 'signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 2), () async  {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        // If logged in, navigate to the home screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const HomePageScreen(),
        ));
      } 
      else {
        // If not logged in, navigate to the sign in screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        ));
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 41, 54, 238),
              Color.fromARGB(255, 102, 192, 214)
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/std_locker.png',
              fit: BoxFit.cover,
            ),
            const Text(
              "Student Locker",
              style: TextStyle(
                fontFamily: "Amiri",
                color: Colors.white,
                fontSize: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
