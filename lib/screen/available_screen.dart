import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_locker/screen/locker_details_screen.dart';
import 'package:student_locker/widgets/custom_widgets.dart';

class AvailableLockersScreen extends StatefulWidget {
  const AvailableLockersScreen({super.key});

  @override
  State<AvailableLockersScreen> createState() => _AvailableLockersScreenState();
}

class _AvailableLockersScreenState extends State<AvailableLockersScreen> {
  final MyCustomWidgets _customWidgets = MyCustomWidgets();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('lockers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while waiting for data
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final documents = snapshot.data!.docs;

          // Filter documents where locker_state is 'Available' (case insensitive)
          final availableLockers = documents.where((doc) =>
              doc['locker_state'].toString().toLowerCase() == 'available');

          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 20.0, horizontal: 30.0),
            child: Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              children: availableLockers.map((doc) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LockerDetailsScreen(lockerId: doc['id']),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 50, // Adjust the width of the locker
                    height: 120, // Adjust the height of the locker
                    child: _customWidgets.containerMethod(
                        Icons.storage,
                        doc['id'].toString(),
                        "Available",
                        Colors.greenAccent),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
