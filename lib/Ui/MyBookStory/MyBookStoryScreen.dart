import 'package:flutter/material.dart';
import 'package:gemini/Api/Firebase/Firestore/FirestoreService.dart';
import 'package:gemini/Api/Gemini/gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/VisualTools.dart';

class MyBookScreenStory extends StatefulWidget {
  const MyBookScreenStory({super.key});

  @override
  State<MyBookScreenStory> createState() => _MyBookScreenStoryState();
}

class _MyBookScreenStoryState extends State<MyBookScreenStory> {
  @override
  String? story="";
  void initState() {
    // TODO: implement initState
    getuserstory();
    
    super.initState();
  }
  void getuserstory()async{
    story=await FirestoreService().getuserstory();
  }
  @override
  
  Widget build(BuildContext context) {
    return  Scaffold(
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
              "Your",
              style: GoogleFonts.akatab(
                  fontWeight: FontWeight.bold,
                  color: HexColor("80C4E9"),
                  fontSize: 20),
            ),
            SizedBox(width: 4),
            Text(
              "Story",
              style: GoogleFonts.akatab(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontSize: 20),
            ),
          ],
        ),  
        actions: [
          IconButton(onPressed: () async{
            bool result =await VisualTools().showConfirmationDialog(context, "Regenerate your story", "This act is irreversible are you sure");
            if (result)

            {
              story=await GeminiPrompt().generatestory();
              setState(() {

              });
              VisualTools().showCustomSnackBar(context, "story generated successfully");
            }

          }, icon: Icon(Icons.refresh)),
          SizedBox(width: 10)
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child:story ==""? Center(child: ElevatedButton(onPressed: ()async{
          story=await GeminiPrompt().generatestory();
setState(() {

});

        },child: Text('generate story'),),) :Text(story!),
      ),
    );
  }
}
