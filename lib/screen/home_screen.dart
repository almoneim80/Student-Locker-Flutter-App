// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:student_locker/constants.dart';
import 'package:student_locker/screen/alllockers_screen.dart';
import 'package:student_locker/screen/available_screen.dart';
import 'package:student_locker/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
    late String fullName = '';
  int _subTabIndex = 0;
   late TabController _tabController;
  final MyCustomWidgets _customWidgets = MyCustomWidgets();
 final List<Widget> _subTabScreens = [
    const AllLockersScreen(),
    const AvailableLockersScreen(),
  ];

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: _subTabScreens.length, vsync: this);
    _tabController.addListener(_handleSubTabChange);
     fetchUserData();
  }

   @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleSubTabChange() {
    setState(() {
      _subTabIndex = _tabController.index;
    });
  }

Future<void> fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('userId') ?? '';

  try {
    // Access Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Query Firestore to check if user exists with the stored user ID
    QuerySnapshot querySnapshot = await users.where('id', isEqualTo: userId).get();

    if (querySnapshot.docs.isNotEmpty) {
      // User found, retrieve user data
      DocumentSnapshot userData = querySnapshot.docs.first;

      setState(() {
        fullName = userData['full_name'];
      });
    } else {
      // User not found or data not available, handle accordingly
      setState(() {
        fullName = "null";
      });
    }
  } catch (error) {
    // Handle any errors that occur during the data retrieval process
    print('Error fetching user data: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: homeScreenBottomAppBar(),
      body: TabBarView(controller: _tabController, children: _subTabScreens),
    );
  }

  AppBar homeScreenBottomAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: homeScreenTopAppBar(),
      bottom: TabBar(
        controller: _tabController,
        labelColor: kPrimaryColor,
        indicator: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kPrimaryColor, width: 2.0)),
        ),
        tabs: const [
          Tab(text: 'All Lockers',),
          Tab(text: 'Available Lockers',)
        ],
        onTap: (index){
          setState(() {
            _subTabIndex = index;
          });
        },
      ),
    );
  }

  Row homeScreenTopAppBar() {
    return Row(
      children: [
        const Icon(Icons.account_circle_rounded, size: 24, color: Colors.black),
        const SizedBox( width: 3.0, ),
        _customWidgets.textMethod("Welcome", Colors.black, 18.0, true),
        const SizedBox(width: 3.0,),
        _customWidgets.textMethod(fullName, kTextColor, 16.0, false),
      ],
    );
  }
}