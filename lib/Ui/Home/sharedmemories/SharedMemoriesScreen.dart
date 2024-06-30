import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Api/Firebase/Firestore/FirestoreService.dart';
import '../../../Models/Memory.dart';
import '../MyMemoriesScreen/Component/component.dart';
import '../OpenMemoryScreen/OpenMemoryScreen.dart';

class Sharedmemoriesscreen extends StatefulWidget {
  const Sharedmemoriesscreen({super.key});

  @override
  State<Sharedmemoriesscreen> createState() => _SharedmemoriesscreenState();
}

class _SharedmemoriesscreenState extends State<Sharedmemoriesscreen> {
  List<Memory> memories = [];

  @override
  void initState() {
    super.initState();
    // Load memories from Firestore when the widget initializes
    _loadMemories();
  }

  // Method to load memories from Firestore
  Future<void> _loadMemories() async {
    try {
      // Replace with your FirestoreService method to fetch memories
      List<Memory> fetchedMemories = await FirestoreService().getPublicMemories(FirebaseAuth.instance.currentUser!.uid);

      setState(() {
        memories = fetchedMemories;
      });
    } catch (e) {
      // Handle error loading memories
      print('Error loading memories: $e');
      // Optionally, show a snackbar or error message to the user
    }
  }

  // Method to handle refresh action
  Future<void> _refresh() async {
    // Simulate a delay before refreshing (you can replace this with actual data fetching logic)
    await Future.delayed(Duration(seconds: 1));

    // Reload memories
    await _loadMemories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("EBF4F6"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Shared",
              style: GoogleFonts.akatab(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Memories",
              style: GoogleFonts.akatab(
                fontWeight: FontWeight.bold,
                color: HexColor("80C4E9"),
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [SizedBox(width: 30,)],
        centerTitle: true,
      ),
      backgroundColor: HexColor("EBF4F6"),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: ListView.builder(
            itemCount: memories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Openmemoryscreen(memory: memories[index])),
                    );
                  },
                  child: HomeMemory(context, memories[index]));
            },
          ),
        ),
      ),
    );
  }
}
