import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:student_locker/constants.dart';
import 'package:student_locker/widgets/custom_widgets.dart';
import 'package:quickalert/quickalert.dart';

class LockerDetailsScreen extends StatefulWidget {
  final String lockerId;

  const LockerDetailsScreen({super.key, required this.lockerId});

  @override
  State<LockerDetailsScreen> createState() => _LockerDetailsScreenState();
}

class _LockerDetailsScreenState extends State<LockerDetailsScreen> {
  final MyCustomWidgets _customWidgets = MyCustomWidgets();
  late String userId; // Declare userId variable

  @override
  void initState() {
    super.initState();
    getUserId(); // Call getUserId function when the screen initializes
  }

  // Function to get user ID from SharedPreferences
  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('userId');
    setState(() {
      userId = storedUserId ?? ''; // Assign storedUserId to userId variable
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: _customWidgets.textMethod(
            "Locker detail",
            Colors.black,
            20.0,
            true,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(159, 154, 175, 194),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Row(
                children: [
                  _customWidgets.textMethod(
                    "Locker Number: ",
                    Colors.black,
                    18.0,
                    false,
                  ),
                  _customWidgets.textMethod(
                    widget.lockerId,
                    kPrimaryColor,
                    18.0,
                    false,
                  ),
                ],
              ),
            ),
          ),
          _customWidgets.textMethod(
            "Press the button to book the locker",
            kPrimaryColor,
            18.0,
            false,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: GestureDetector(
              onTap: () async {
                // Access Firestore collection
                CollectionReference lockers =
                    FirebaseFirestore.instance.collection('lockers');
                try {
                  // Query Firestore to find if the user has already booked a locker
                  QuerySnapshot userQuerySnapshot = await lockers
                      .where('user_id', isEqualTo: userId.toString())
                      .get();

                  if (userQuerySnapshot.docs.isNotEmpty) {
                    // User has already booked a locker, show error message using QuickAlert
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Error',
                      text: 'You have already booked a locker.',
                      confirmBtnText: 'OK',
                      confirmBtnColor: kPrimaryColor,
                    );
                  } else {
                    // User has not booked a locker, proceed with booking

                    // Query Firestore to find the locker document with the provided ID
                    QuerySnapshot querySnapshot = await lockers
                        .where('id', isEqualTo: widget.lockerId)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      // Locker found, update its data
                      await lockers.doc(querySnapshot.docs.first.id).update({
                        'locker_state': 'booked',
                        'book_date':
                            DateTime.now().toString(), // Set to today's date
                        'user_id': userId.toString(), // Use userId variable
                      });

                      // Show success message using QuickAlert
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: 'Locker Booked Successfully!',
                        text: '',
                        confirmBtnText: 'OK',
                        confirmBtnColor: kPrimaryColor,
                        onConfirmBtnTap: () {
                          Navigator.pop(context); // Dismiss the current screen
                          Navigator.pushNamed(
                            context,
                            'MyLockerScreen',
                            arguments: {
                              'lockerId': widget.lockerId
                            }, // Pass lockerId as an argument
                          );
                        },
                      );
                    } else {
                      // Locker not found, show error message using QuickAlert
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Error',
                        text: 'Locker not found. Please try again later.',
                        confirmBtnText: 'OK',
                        confirmBtnColor: kPrimaryColor,
                      );
                    }
                  }
                } catch (error) {
                  print('Firestore query error: $error');

                  // Show error message using QuickAlert
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Error',
                    text: 'An error occurred. Please try again later.',
                    confirmBtnText: 'OK',
                    confirmBtnColor: kPrimaryColor,
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 100.0),
                  child: _customWidgets.textMethod(
                    "Book Now",
                    Colors.white,
                    18.0,
                    true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
