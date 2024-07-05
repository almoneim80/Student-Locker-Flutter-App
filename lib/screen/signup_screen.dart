// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_locker/constants.dart';
import 'package:student_locker/widgets/custom_widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String FullName;
  late String Id;
  late String PhoneNumber;
  late String Password;
  bool _saving = false;

  final MyCustomWidgets _customWidgets = MyCustomWidgets();
  bool _isPasswordVisible = false;
  var numericInputFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
  ];
  var alphabeticInputFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FFa-zA-Z\s]')),
  ];

  //this method for open Sign Up Screen
  void openSignInScreen() {
    Navigator.of(context).pushReplacementNamed("SignInScreen");
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
              _customWidgets.textMethod(
                  "Create account", Colors.white, 35.0, true),
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
                        _customWidgets.textMethod(
                            "Full Name", kTextColor, 15.0, false),
                        TextField(
                          onChanged: (value) {
                            FullName = value;
                          },
                          cursorColor: kTextColor,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          inputFormatters: alphabeticInputFormatter,
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
                            hintText: "Enter your name",
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
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        _customWidgets.textMethod(
                            "Your Id", kTextColor, 15.0, false),
                        TextField(
                          onChanged: (value) {
                            Id = value;
                          },
                          cursorColor: kTextColor,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: numericInputFormatter,
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
                            hintText: "Enter your id",
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
                        _customWidgets.textMethod(
                            "Phone Number", kTextColor, 15.0, false),
                        TextField(
                          onChanged: (value) {
                            PhoneNumber = value;
                          },
                          cursorColor: kTextColor,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          inputFormatters: numericInputFormatter,
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
                            hintText: "+966 ** *** ***",
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
                              Icons.phone,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        _customWidgets.textMethod(
                            "Password", kTextColor, 15.0, false),
                        TextField(
                          onChanged: (value) {
                            Password = value;
                          },
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
                            hintText: "Enter your password",
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
                        const SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              _saving = true;
                            });
                            CollectionReference collRef =
                                FirebaseFirestore.instance.collection('users');
                            try {
                              await collRef.add({
                                'full_name': FullName,
                                'id': Id,
                                'password': Password,
                                'phone_number': PhoneNumber
                              });
                              // Navigate to the login screen after successful registration.
                              openSignInScreen();
                              setState(() {
                                _saving = false;
                              });
                            } catch (error) {
                              print('Firestore insertion error: $error');
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Center(
                                child: _customWidgets.textMethod(
                                    "Create account",
                                    Colors.white,
                                    15.0,
                                    false),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _customWidgets.textMethod(
                                "Already have an account ? ",
                                kTextColor,
                                15.0,
                                false),
                            GestureDetector(
                              onTap: openSignInScreen,
                              child: _customWidgets.textMethod(
                                  "Login", kPrimaryColor, 15.0, false),
                            ),
                          ],
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
