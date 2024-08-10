import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/Api/Firebase/Firestore/FirestoreService.dart';
import 'package:gemini/BusinessLogic/Memories/memory_event.dart';
import 'package:gemini/BusinessLogic/Memories/memory_bloc.dart';
import 'package:gemini/BusinessLogic/Memories/memory_state.dart';
import 'package:gemini/Ui/Home/AllMyMemoriesScreen/AllMyMemoriesScreen.dart';
import 'package:gemini/Ui/Home/MyMemoriesScreen/Component/component.dart';
import 'package:gemini/Ui/Home/OpenMemoryScreen/OpenMemoryScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '../NewMemoryScreen/NewMemoryScreen.dart';

class MyMemoriesScreen extends StatefulWidget {
  const MyMemoriesScreen({Key? key}) : super(key: key);

  @override
  _MyMemoriesScreenState createState() => _MyMemoriesScreenState();
}

class _MyMemoriesScreenState extends State<MyMemoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MemoryBloc(FirestoreService())
        ..add(LoadUserMemories(
            FirebaseAuth.instance.currentUser!.uid.toString())),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NewMemoryScreen()),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          backgroundColor: HexColor("80C4E9"),
        ),
        backgroundColor: HexColor("EBF4F6"),
        appBar: AppBar(
          backgroundColor: HexColor("EBF4F6"),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
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
                "Back",
                style: GoogleFonts.akatab(
                  fontWeight: FontWeight.bold,
                  color: HexColor("80C4E9"),
                  fontSize: 20,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20,right: 20),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.orange
                ),
                child: Text(
                  "Are you here to relive cherished memories or to create new unforgettable experiences ??? ",
                  style: GoogleFonts.akatab(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Some of your Memories :",
                    style: GoogleFonts.akatab(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllMyMemoriesScreen()),
                      );
                    },
                    child: Text(
                      "more",
                      style: GoogleFonts.akatab(
                        fontWeight: FontWeight.normal,
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocBuilder<MemoryBloc, MemoryState>(
                  builder: (context, state) {
                    if (state is MemoryLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is MemoryLoaded) {
                      return Column(
                        children: state.memories.map((memory) {
                          return GestureDetector(
                            onTap: () async {
                              // Navigate to Openmemoryscreen and wait for result
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Openmemoryscreen(memory: memory),
                                ),
                              );
                              await Future.delayed(Duration(seconds: 1));
                              setState(() {});
                              // Check if result indicates a need to reload memories
                              if (result) {
                                // Reload memories
                                BlocProvider.of<MemoryBloc>(context).add(
                                  LoadUserMemories(FirebaseAuth.instance.currentUser!.uid),
                                );
                                setState(() {});
                              }
                            },
                            child: HomeMemory(context, memory),
                          );
                        }).toList(),
                      );

                    } else if (state is MemoryError) {
                      return Center(
                          child: Text(
                              'Failed to load memories: ${state.message}'));
                    } else {
                      return Center(child: Text('No memories available.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
