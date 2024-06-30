import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gemini/Api/Firebase/Firestore/FirestoreService.dart';
import 'package:gemini/Models/Memory.dart';
import 'package:gemini/utils/VisualTools.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Openmemoryscreen extends StatefulWidget {
  final Memory memory;
  const Openmemoryscreen({super.key, required this.memory});

  @override
  State<Openmemoryscreen> createState() => _OpenmemoryscreenState();
}

class _OpenmemoryscreenState extends State<Openmemoryscreen> {
  @override
  bool favorite = false;
  bool shared = false;
  bool owner=false;
  void initState() {
    // TODO: implement initState
    super.initState();
    favorite=widget.memory.favorite;
    shared=widget.memory.state=="public";
    owner=FirebaseAuth.instance.currentUser!.uid==widget.memory.ownerid;

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: HexColor("EBF4F6"),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: HexColor("EBF4F6"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Travel",
              style: GoogleFonts.akatab(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontSize: 20),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Back",
              style: GoogleFonts.akatab(
                  fontWeight: FontWeight.bold,
                  color: HexColor("80C4E9"),
                  fontSize: 20),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    setState(() {
                      favorite = !favorite;
                    });   if (favorite) {
                     if(owner){
                       await FirestoreService().makefavorite(
                           FirebaseAuth.instance.currentUser!.uid,
                           widget.memory);
                     }else{
                       await FirestoreService().makefavoritepublic(
                           FirebaseAuth.instance.currentUser!.uid,
                           widget.memory);
                     }
                    } else {
                     if(owner){
                       await FirestoreService().deletefavorite(
                           FirebaseAuth.instance.currentUser!.uid,
                           widget.memory);
                     }else{
                       await FirestoreService().deletefavoritepublic(
                           FirebaseAuth.instance.currentUser!.uid,
                           widget.memory);

                     }
                    }


                  },
                  icon: Icon(
                    Icons.favorite,
                    color: favorite ? Colors.orange : Colors.grey,
                  )),
              Visibility(
                visible: owner,
                child: IconButton(
                    onPressed: () async {
                      bool result = await VisualTools().showConfirmationDialog(
                        context,
                        "Are you sure",
                        "you can share it or unshare it any time ",
                      );
                      if (result) {
                    setState(() {
                    shared = !shared;
                    });   if (shared) {
                    await FirestoreService().makeitpublic(
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.memory);
                    } else {
                    await FirestoreService().makeitprivate(
                    FirebaseAuth.instance.currentUser!.uid, widget.memory);

                    }}
                    },
                    icon: Icon(
                      Icons.share,
                      color:shared? Colors.blue : Colors.grey,
                    )),
              ),
              Visibility(
                visible: owner,
                child: IconButton(
                    onPressed: () async {
                      bool result = await VisualTools().showConfirmationDialog(
                        context,
                        "Are you sure",
                        "This act couldn't be reversed ",
                      );
                      if (result) {
                        FirestoreService().deleteMemory(
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.memory);
                        Navigator.of(context).pop(true);
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.blue,
                    )),
              )
            ],
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              widget.memory.title,
              style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: 22),
            ),
            SizedBox(
              height: 15,
            ),
            widget.memory.imageUrl != ""
                ? Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(widget.memory.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.memory.generated,
              style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 14),
            ),
            SizedBox(height: 24),
            Text(
              widget.memory.date.substring(0, 16),
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              'By Mohammed Fraj',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '___________________',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Image.network(
              widget.memory.signaturePhotoUrl,
              scale: 1.8,
              alignment: Alignment.topLeft,
            )
          ],
        ),
      ),
    );
  }
}
