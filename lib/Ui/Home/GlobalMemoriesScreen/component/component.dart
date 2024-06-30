import 'package:flutter/material.dart';
import 'package:gemini/Models/Memory.dart';
import 'package:gemini/Ui/Home/OpenMemoryScreen/OpenMemoryScreen.dart';
import 'package:gemini/Ui/WelcomeScreen/WelcomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';

Widget GlobalMemory(BuildContext context,Memory memory) {
  return Container(
    margin: EdgeInsets.only(top: 12),
    padding: EdgeInsets.all(14),
    width: double.infinity,
    height: 400,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(memory.userphoto!), // replace with your image asset
                ),
                SizedBox(width: 10),
                Text(
                  memory.username!,
                  style: GoogleFonts.akatab(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                    fontSize: 20,
                  ),
                ),
              ],
            ),

          ],
        ),
        SizedBox(height: 20),
        Text(
          memory.title,
          style: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.w800,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '''${memory.generated.trim()}''',
          style: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 14,
          ),
          maxLines:memory.imageUrl==""? 5:3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10),
        Visibility(
          visible: memory.imageUrl!="",
          child: Container(
            child: Image.network(
              memory.imageUrl==""? "" :memory.imageUrl!, // replace with your image asset
              fit: BoxFit.cover,

              height: 100, // adjust the height as needed
              width: double.infinity,
            ),
          ),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Openmemoryscreen(memory: memory),
                ),
              );
            },
            child: Text(
              'See more',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

