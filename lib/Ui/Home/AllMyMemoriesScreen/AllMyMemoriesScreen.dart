import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gemini/Api/Firebase/Firestore/FirestoreService.dart';
import 'package:gemini/Models/Memory.dart';
import 'package:gemini/Ui/Home/MyMemoriesScreen/Component/component.dart';
import 'package:gemini/Ui/Home/OpenMemoryScreen/OpenMemoryScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class AllMyMemoriesScreen extends StatefulWidget {
  const AllMyMemoriesScreen({super.key});

  @override
  State<AllMyMemoriesScreen> createState() => _AllMyMemoriesScreenState();
}

class _AllMyMemoriesScreenState extends State<AllMyMemoriesScreen> {
  List<Memory> memories =[]; // Initial list of memories
TextEditingController _search=TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    // Simulate a network request or data fetching
    await Future.delayed(Duration(seconds: 2));
    memories = await FirestoreService().searchMemories(_search.text);
    setState(() {
      // Updated list of memories
    });
  }

  Future<void> _refreshMemories() async {
    await _loadMemories(); // Reload the memories
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("EBF4F6"),
      appBar: AppBar(
        backgroundColor: HexColor("EBF4F6"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Explore",
              style: GoogleFonts.akatab(
                  fontWeight: FontWeight.bold,
                  color: HexColor("80C4E9"),
                  fontSize: 20),
            ),
            SizedBox(width: 4),
            Text(
              "Memories",
              style: GoogleFonts.akatab(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontSize: 20),
            ),
          ],
        ),
        actions: [
          SizedBox(width: 50)
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.white),
              child: TextField(
                onChanged: (t){
                  _loadMemories();
                },
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.black),

                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshMemories,
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
          ],
        ),
      ),
    );
  }
}
