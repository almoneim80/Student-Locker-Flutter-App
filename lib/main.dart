import 'package:flutter/material.dart';
import 'package:student_locker/screen/home_screen.dart';
import 'package:student_locker/screen/homepage_screen.dart';
import 'package:student_locker/screen/mylocker_screen.dart';
import 'package:student_locker/screen/signin_screen.dart';
import 'package:student_locker/screen/signup_screen.dart';
import "screen/splash_screen.dart";
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: 'AIzaSyD-VGdm_k0B9-Co69_7ycVJc4DuYk2m4V4',
      appId: '1:729178517770:android:d11939b190924a4bbd0af3',
      messagingSenderId: '729178517770',
      projectId: 'student-locker-ccedf',
      storageBucket: 'student-locker-ccedf.appspot.com',
    ));
  } catch (error) {
    print('Firebase initialization error: $error');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Locker',
      home: const SplashScreen(),
      routes: {
        "HomePageScreen": (context) => const HomePageScreen(),
        "HomeScreen": (context) => const HomeScreen(),
        "SignInScreen": (context) => const SignInScreen(),
        "SignUpScreen": (context) => const SignUpScreen(),
        "MyLockerScreen": (context) => const MyLockerScreen(),
      },
    );
  }
}
