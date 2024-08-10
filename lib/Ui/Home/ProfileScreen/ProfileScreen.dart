import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gemini/Api/Firebase/Authentification/FirebaseAuth.dart';
import 'package:gemini/Api/Firebase/Firestore/FirestoreService.dart';
import 'package:gemini/Models/User.dart';
import 'package:gemini/Ui/Home/AllMyMemoriesScreen/AllMyMemoriesScreen.dart';
import 'package:gemini/Ui/Home/sharedmemories/SharedMemoriesScreen.dart';
import 'package:gemini/Ui/MyBookStory/MyBookStoryScreen.dart';
import 'package:gemini/Ui/WelcomeScreen/WelcomeScreen.dart';
import 'package:gemini/utils/VisualTools.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    user = await FirestoreService()
        .getUserData(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: HexColor("EBF4F6"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your",
              style: GoogleFonts.akatab(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 4),
            Text(
              "Profile",
              style: GoogleFonts.akatab(
                fontWeight: FontWeight.bold,
                color: HexColor("80C4E9"),
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit, color: Colors.orange),
              ),
              IconButton(
                onPressed: () async {
                  bool res = await VisualTools().showConfirmationDialog(
                      context, "Are you sure", "Logout of the account");
                  if (res) {
                    await AuthService().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()),
                    );
                  }
                },
                icon: Icon(Icons.login_outlined, color: Colors.blue),
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        color: HexColor("EBF4F6"),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user!.photoUrl),
                    ),
                    SizedBox(height: 20),
                    Text(
                      user!.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Flutter Developer', // Replace with user's bio or profession
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.blue),
                      title: Text(user!.email),
                      onTap: () {
                        // Handle tapping on email (e.g., open email app)
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.file_copy_sharp, color: Colors.blue),
                      title: Text('All Memories'),
                      onTap: () {
                        // Handle tapping on All Memories
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllMyMemoriesScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.wifi, color: Colors.blue),
                      title: Text('Shared Memories'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Sharedmemoriesscreen()),
                        );
                        // Handle tapping on Shared Memories
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.book, color: Colors.blue),
                      title: Text('Your Story'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyBookScreenStory()),
                        );
                        // Handle tapping on Shared Memories
                      },
                    ),
                    // Add more ListTile widgets for additional user information
                  ],
                ),
        ),
      ),
    );
  }
}
