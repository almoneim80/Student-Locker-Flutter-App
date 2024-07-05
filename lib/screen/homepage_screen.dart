import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:student_locker/screen/home_screen.dart';
import 'package:student_locker/screen/mylocker_screen.dart';
import 'package:student_locker/screen/profile_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> with SingleTickerProviderStateMixin {
   int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MyLockerScreen(),
    const ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: _screens[_selectedIndex],
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }

  Container bottomNavigationBar(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromARGB(159, 154, 175, 194),
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.white),
          child: GNav(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            tabBorderRadius: 10.0,
            tabActiveBorder: Border.all(
            color: const Color.fromARGB(255, 117, 148, 247), width: 1),
            gap: 10,
            duration: const Duration(milliseconds: 400),
            tabs: const [
              GButton(
                icon: Icons.home_rounded,
                text: 'Home',
              ),
              GButton(icon: Icons.storage, text: 'My Locker'),
              GButton(icon: Icons.person, text: 'Profile')
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index){
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ));
  }
}