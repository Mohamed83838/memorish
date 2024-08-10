import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemini/Ui/Home/Navbar/NavBarScreen.dart';
import 'package:gemini/Ui/Identification/IdentificationScreen.dart';
import 'package:gemini/Ui/MyBookStory/MyBookStoryScreen.dart';
import 'package:gemini/Ui/WelcomeScreen/WelcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? welcomeScreenShown = prefs.getBool('welcomeScreenShown');
  User? user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(welcomeScreenShown: welcomeScreenShown ?? false, user: user));
}

class MyApp extends StatelessWidget {
  final bool welcomeScreenShown;
  final User? user;
  MyApp({required this.welcomeScreenShown,required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gemini Competition',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

      ),
      home: user != null ? Navbarscreen() : (welcomeScreenShown ? IdentificationScreen() : WelcomeScreen()),
    );
  }
}
