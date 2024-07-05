import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_locker/widgets/custom_widgets.dart';
import 'package:student_locker/constants.dart';

class MyLockerScreen extends StatefulWidget {
  const MyLockerScreen({super.key});

  @override
  State<MyLockerScreen> createState() => _MyLockerScreenState();
}

class _MyLockerScreenState extends State<MyLockerScreen> {
  final MyCustomWidgets _customWidgets = MyCustomWidgets();
  late String userId = '';

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: _customWidgets.textMethod("My Locker", Colors.black, 20.0, true),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lockers')
            .where('user_id', isEqualTo: userId)
            .where('locker_state', isEqualTo: 'booked')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final lockers = snapshot.data!.docs;
            if (lockers.isEmpty) {
              return const Center(
                child: Text(
                  'You have not booked any lockers.',
                  style: TextStyle(
                    fontFamily: "Amiri",
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.grey,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: lockers.map((doc) {
                  final lockerId = doc['id'];
                  final bookDate = DateTime.parse(doc['book_date']).toLocal();
                  final formattedDate =
                      '${bookDate.day}/${bookDate.month}/${bookDate.year}';
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(
                                  20.0), // Add padding around the content
                              height: 300,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.lock_open, // Open lock icon
                                    size: 150,
                                  ),
                                  const Text(
                                    "Locker is Open",
                                    style: TextStyle(fontSize: 20, fontFamily: "Amiri",),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor, // Change the background color here
                                    ),
                                    child: const Text("Close Now", style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: "Amiri",),),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: _customWidgets.cardMethod(Icons.lock, lockerId,
                          formattedDate, Icons.arrow_forward),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
