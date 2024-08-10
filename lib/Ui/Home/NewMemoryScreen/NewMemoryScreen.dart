import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gemini/Api/Firebase/Firestore/FirestoreService.dart';
import 'package:gemini/Api/Firebase/storage/FirebaseStorage.dart';
import 'package:gemini/Api/Gemini/gemini.dart';
import 'package:gemini/Models/Memory.dart';
import 'package:gemini/Ui/Home/MyMemoriesScreen/MyMemoriesScreen.dart';
import 'package:gemini/Ui/Home/Navbar/NavBarScreen.dart';
import 'package:gemini/Ui/Home/NewMemoryScreen/component/component.dart';
import 'package:gemini/utils/VisualTools.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:signature/signature.dart';
import '../../../Models/GeminiResponse.dart';
import '../../../Models/User.dart';
import '../../../utils/Tools.dart';

enum MemoryType { joke, musiclyrics, poetry, story }

class NewMemoryScreen extends StatefulWidget {
  const NewMemoryScreen({super.key});

  @override
  State<NewMemoryScreen> createState() => _NewMemoryScreenState();
}

class _NewMemoryScreenState extends State<NewMemoryScreen> {
  MemoryType selected = MemoryType.story;
  bool public = false;
  File? file;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;
  FirestoreService firestoreService = FirestoreService();
  SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  @override
  void dispose() {
    // Dispose the controller to free up resources
    _controller.dispose();
    super.dispose();
  }

  // Method to save the signature
  Future<String?> _saveSignature() async {
    if (_controller.isNotEmpty) {
      // Convert the signature to PNG bytes
      final Uint8List? data = await _controller.toPngBytes();
      if (data != null) {
        // Upload the file to Firebase
        String userId = FirebaseAuth
            .instance.currentUser!.uid; // Replace with the actual user ID
        String? downloadUrl = await FirestoreStorageService()
            .uploadsignature(data, userId, DateTime.now().toString());

        if (downloadUrl != null) {
          // Show a SnackBar notification with the file URL
          return downloadUrl;
        } else {
          // Handle upload error
        }
      }
    }
  }

  // Method to clear the signature
  void _clearSignature() {
    _controller.clear();
  }

  Future<void> saveMemory() async {
    setState(() {
      loading = true;
    });
    String? url = "";
    if (file?.path != null) {
      url = await FirestoreStorageService()
          .uploadPhoto(file!, FirebaseAuth.instance.currentUser!.uid);
    }
    Response? res = await GeminiPrompt().promptText(descriptionController.text,
        titleController.text == "", selected.toString().split('.').last);
    UserModel? user = await FirestoreService()
        .getUserData(FirebaseAuth.instance.currentUser!.uid);
    String? signatureurl = await _saveSignature();
    if (res != null) {
      final memory = Memory(
        originalmemory: descriptionController.text,
        ownerid: FirebaseAuth.instance.currentUser!.uid,
        favorite: false,
        userphoto: user!.photoUrl,
        username: user.name,
        generated: res.description,
        title: titleController.text == "" ? res.title : titleController.text,
        description: descriptionController.text,
        type: selected.toString().split('.').last,
        imageUrl: url,
        signaturePhotoUrl: signatureurl == null
            ? ""
            : signatureurl, // Add appropriate logic if needed
        state: public ? "public" : 'private',
        date: DateTime.now().toString(),
      );

      try {
        await firestoreService.saveMemory(
            FirebaseAuth.instance.currentUser!.uid, memory);

        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Navbarscreen()),
        );
      } catch (e) {
        print('Error saving memory: $e');
      }
    } else {
      VisualTools().showCustomSnackBar(context, "An error occured");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: HexColor("EBF4F6"),
          appBar: AppBar(
            leading: IgnorePointer(
              ignoring:  loading,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Navbarscreen()),
                  );
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            backgroundColor: HexColor("EBF4F6"),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New",
                  style: GoogleFonts.akatab(
                      fontWeight: FontWeight.bold,
                      color: HexColor("80C4E9"),
                      fontSize: 20),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "Memory",
                  style: GoogleFonts.akatab(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                      fontSize: 20),
                ),
              ],
            ),
            actions: [
              IgnorePointer(
                ignoring: loading,
                child: IconButton(
                  onPressed: saveMemory,
                  icon: Icon(Icons.save),
                ),
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(
                  "Choose a type :",
                  style: GoogleFonts.akatab(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = MemoryType.story;
                            });
                          },
                          child: MemoryTypeWidget(
                              "story.png", selected == MemoryType.story)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = MemoryType.musiclyrics;
                            });
                          },
                          child: MemoryTypeWidget(
                              "music.png", selected == MemoryType.musiclyrics)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = MemoryType.poetry;
                            });
                          },
                          child: MemoryTypeWidget(
                              "poetry.png", selected == MemoryType.poetry)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = MemoryType.joke;
                            });
                          },
                          child: MemoryTypeWidget(
                              "joke.png", selected == MemoryType.joke)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Add A Title :",
                      style: GoogleFonts.akatab(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "You can Let the Ai decide",
                      style: GoogleFonts.akatab(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: titleController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Add a Title',
                      hintStyle: TextStyle(color: Colors.grey),
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
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Add A Description :",
                      style: GoogleFonts.akatab(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Describe your Experience ...',
                      hintStyle: TextStyle(color: Colors.grey),
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Make it public :",
                      style: GoogleFonts.akatab(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    Switch(
                        value: public,
                        onChanged: (v) {
                          setState(() {
                            public = !public;
                          });
                        })
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add An Image :",
                      style: GoogleFonts.akatab(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                file == null
                    ? Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: HexColor('1F1D2B'),
                            radius: 30,
                            child: Center(
                              child: IconButton(
                                splashRadius: 0.1,
                                onPressed: () async {
                                  file = await Tools().getImage();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.image_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: HexColor("252836"),
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: FileImage(file!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sign your memory :",
                      style: GoogleFonts.akatab(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    IconButton(
                        onPressed: () {
                          _clearSignature();
                        },
                        icon: Icon(Icons.clear))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: HexColor("252836"),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Expanded(
                    child: Signature(
                      controller: _controller,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                IgnorePointer(
                  ignoring: loading,
                  child: GestureDetector(
                    onTap: () {
                      if (descriptionController.text == "") {
                        VisualTools().showCustomSnackBar(
                            context, "The description is required");
                      } else {
                        saveMemory();
                      }
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
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Visibility(
          visible: loading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}
