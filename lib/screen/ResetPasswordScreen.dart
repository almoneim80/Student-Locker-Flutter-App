import 'package:flutter/material.dart';
import 'package:student_locker/constants.dart';
import 'package:student_locker/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isPasswordVisible = false;
  bool _saving = false;

  final MyCustomWidgets _customWidgets = MyCustomWidgets();
  TextEditingController idController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  void resetPassword() async {
    String enteredId = idController.text;
    String newPassword = newPasswordController.text;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      QuerySnapshot querySnapshot = await users
          .where('id', isEqualTo: enteredId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User found, update password
        String userId = querySnapshot.docs.first.id;
        await users.doc(userId).update({'password': newPassword});

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: const Text("Password has been reset successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Navigate back to the login screen
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        // User not found, display error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: const Text("User not found. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print('Firestore query error: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("An error occurred. Please try again later."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: kPrimaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 130.0,
              ),
              _customWidgets.textMethod("Reset Password", Colors.white, 35.0, false),
              const SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _customWidgets.textMethod("ID Number", kTextColor, 15.0, false),
                        TextField(
                          controller: idController,
                          cursorColor: kTextColor,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: kTextColor, width: 1.0),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: kTextColor, width: 1.0),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: "Enter your ID number",
                            hintStyle: const TextStyle(
                              fontFamily: "Amiri",
                              fontWeight: FontWeight.bold,
                              color: kTextColor,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            suffixIcon: const Icon(
                              Icons.badge,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        _customWidgets.textMethod("New Password", kTextColor, 15.0, false),
                        TextField(
                          controller: newPasswordController,
                          cursorColor: kTextColor,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kTextColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kTextColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: "Enter your new password",
                            hintStyle: const TextStyle(
                              fontFamily: "Amiri",
                              fontWeight: FontWeight.bold,
                              color: kTextColor,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _saving = true;
                              });
                              resetPassword();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Center(
                                child: _customWidgets.textMethod(
                                  "Reset Password",
                                  Colors.white,
                                  15.0,
                                  false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
