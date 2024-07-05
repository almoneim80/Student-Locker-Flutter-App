import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_locker/screen/locker_details_screen.dart';
import 'package:student_locker/widgets/custom_widgets.dart';

class AllLockersScreen extends StatefulWidget {
  const AllLockersScreen({super.key});

  @override
  State<AllLockersScreen> createState() => _AllLockersScreenState();
}

class _AllLockersScreenState extends State<AllLockersScreen> {
  final MyCustomWidgets _customWidgets = MyCustomWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('lockers').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final lockers = snapshot.data!.docs;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: lockers.map((doc) {
                  final id = doc['id'];
                  final lockerState = doc['locker_state'];
                  final color = lockerState.toLowerCase() == 'available'
                      ? Colors.greenAccent
                      : Colors.redAccent;
                  final onTap = lockerState.toLowerCase() == 'available'
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LockerDetailsScreen(lockerId: id),
                            ),
                          );
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "You cannot open the locker with the number $id because it is already booked!"),
                            ),
                          );
                        };

                  return GestureDetector(
                    onTap: onTap,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 50, // Adjust the width of the locker
                      height: 120, // Adjust the height of the locker
                      child: _customWidgets.containerMethod(
                          Icons.storage, id.toString(), lockerState, color),
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
