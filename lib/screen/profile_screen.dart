import 'package:flutter/material.dart';
import 'package:student_locker/constants.dart';
import 'package:student_locker/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_locker/screen/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String fullName = '';
  late String id = '';
  final MyCustomWidgets _customWidgets = MyCustomWidgets();
  late DocumentSnapshot userData; // Declare userData here

  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget initializes
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    id = userId;

    try {
      // Access Firestore collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Query Firestore to check if user exists with the stored user ID
      QuerySnapshot querySnapshot =
          await users.where('id', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // User found, retrieve user data
        userData = querySnapshot.docs.first; // Assign userData here

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

void showProfileDropdown(DocumentSnapshot userData) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Full Name : ",
                      style: TextStyle(
                        fontFamily: "Amiri",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  userData['full_name'] ?? 'Unknown',
                  style: const TextStyle(
                    fontFamily: "Amiri",
                    fontSize: 20.0,
                    color: Colors.grey, // Changed to grey color
                  ),
                ),
              ],
            ),
            const Divider(), // Divider between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.format_list_numbered,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Id : ",
                      style: TextStyle(
                        fontFamily: "Amiri",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  userData['id'] ?? 'Unknown',
                  style: const TextStyle(
                    fontFamily: "Amiri",
                    fontSize: 20.0,
                    color: Colors.grey, // Changed to grey color
                  ),
                ),
              ],
            ),
            const Divider(), // Divider between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Phone Number : ",
                      style: TextStyle(
                        fontFamily: "Amiri",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  userData['phone_number'] ?? 'Unknown',
                  style: const TextStyle(
                    fontFamily: "Amiri",
                    fontSize: 20.0,
                    color: Colors.grey, // Changed to grey color
                  ),
                ),
              ],
            ),
            const Divider(), // Divider between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Password : ",
                      style: TextStyle(
                        fontFamily: "Amiri",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  userData['password'] ?? 'Unknown',
                  style: const TextStyle(
                    fontFamily: "Amiri",
                    fontSize: 20.0,
                    color: Colors.grey, // Changed to grey color
                  ),
                ),
              ],
            ),
            // Add more Rows for additional user data if needed
          ],
        ),
      );
    },
  );
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: _customWidgets.textMethod("Profile", Colors.black, 20.0, true),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // row for Avatar + name + id
              Row(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage("images/person.jpeg"),
                  ),
                ),
                Column(
                  children: [
                    _customWidgets.textMethod(
                        fullName.toString(), Colors.black, 20.0, true),
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: _customWidgets.textMethod(
                          id.toString(), kTextColor, 15.0, true),
                    ),
                  ],
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: _customWidgets.textMethod(
                    "personal Info", Colors.black, 12.0, true),
              ),
              // row for profile section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outline),
                        const SizedBox(width: 10.0),
                        _customWidgets.textMethod(
                            "Profile", Colors.black, 18.0, true),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        await fetchUserData(); 
                        showProfileDropdown(userData);
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: _customWidgets.textMethod(
                    "General", Colors.black, 12.0, true),
              ),
              // column for language +  Help
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Column(
                  children: [
                    // row for language
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.language),
                            const SizedBox(
                              width: 10.0,
                            ),
                            _customWidgets.textMethod(
                                "Language", Colors.black, 18.0, true),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 18.0,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.help_outline_outlined),
                            const SizedBox(
                              width: 10.0,
                            ),
                            _customWidgets.textMethod(
                                "Help & Support", Colors.black, 18.0, true),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink, width: 1.0),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 2.0,
                  )
                ],
              ),
              child: Center(
                child: GestureDetector(
                    onTap: () async {
                      // Clear the saved login state
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', false);

                      // Navigate to the sign in screen
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const SignInScreen(),
                      ));
                    },
                    child: _customWidgets.textMethod(
                        "Log out", Colors.pink, 20.0, true)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
