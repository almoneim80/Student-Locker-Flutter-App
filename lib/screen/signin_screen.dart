import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_locker/constants.dart';
import 'package:student_locker/screen/ResetPasswordScreen.dart';
import 'package:student_locker/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;
  bool _isChecked = false;
  bool _saving = false;

  final MyCustomWidgets _customWidgets = MyCustomWidgets();
  var numericInputFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
  ];

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void openSignUpScreen() {
    Navigator.of(context).pushReplacementNamed("SignUpScreen");
  }

  void homePageScreen() {
    Navigator.of(context).pushReplacementNamed("HomePageScreen");
  }

  void openResetPasswordScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
    );
  }

  void signIn() async {
    String enteredId = idController.text;
    String enteredPassword = passwordController.text;

    // Access Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      // Query Firestore to check if user exists with entered ID
      QuerySnapshot querySnapshot =
          await users.where('id', isEqualTo: enteredId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // User found, check password
        String actualPassword = querySnapshot.docs.first['password'];
        //String actualId = querySnapshot.docs.first['id'];

        if (actualPassword == enteredPassword) {
          // Passwords match, navigate to home page
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_isChecked) {
            // If "Remember me" is checked, save login state and user ID
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('userId', enteredId);
          }
          await prefs.setString('userId', enteredId);
          homePageScreen();
          setState(() {
            _saving = false;
          });
        } else {
          // Passwords don't match, display error message
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Login Failed"),
              content: const Text("Invalid ID or Password. Please try again."),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _saving = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        // User not found, display error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("Invalid ID or Password. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _saving = false;
                  });
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
                setState(() {
                  _saving = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
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
              _customWidgets.textMethod("Sign In", Colors.white, 35.0, false),
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
                            "Your Id", kTextColor, 15.0, false),
                        TextField(
                          controller: idController,
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
                            "Password", kTextColor, 15.0, false),
                        TextField(
                          controller: passwordController,
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
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                              checkColor: kTextColor,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return kPrimaryColor;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isChecked = !_isChecked;
                                });
                              },
                              child: _customWidgets.textMethod(
                                  'Remember me', kTextColor, 15.0, false),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: openResetPasswordScreen,
                              child: _customWidgets.textMethod(
                                  "Forget Password", Colors.red, 15.0, false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _saving = true;
                              });
                              signIn();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Center(
                                child: _customWidgets.textMethod(
                                  "Sign In",
                                  Colors.white,
                                  15.0,
                                  false,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _customWidgets.textMethod(
                                "Don't have an account ? ",
                                kTextColor,
                                15.0,
                                false),
                            GestureDetector(
                              onTap: openSignUpScreen,
                              child: _customWidgets.textMethod(
                                "Sign Up",
                                kPrimaryColor,
                                15.0,
                                false,
                              ),
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
