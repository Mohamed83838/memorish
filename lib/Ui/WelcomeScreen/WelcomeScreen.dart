import 'package:flutter/material.dart';
import 'package:gemini/Ui/Identification/IdentificationScreen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#EBF4F6"),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/images/welcome.png"),
            Container(
              child: Text(
                'Unleash the power of your memories with AI!',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: HexColor("252836")),
              ),
            ),
            Container(
                child: Text(
                  "Memory Melody is your ultimate app to transform your memories into creative expressions. Whether it's a song, a story, a poem, or even a joke, our AI technology brings your memories to life in the most captivating ways.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                )),
            GestureDetector(
              onTap: () async {
                // Save to shared preferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('welcomeScreenShown', true);

                // Navigate to the main screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => IdentificationScreen()), // Replace with your main screen
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: HexColor("FF7F3E")),
                child: Center(
                  child: Text(
                    "Start",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
