import 'package:flutter/material.dart';
import 'package:gemini/Models/Memory.dart';
import 'package:google_fonts/google_fonts.dart';

Widget HomeMemory(BuildContext context,Memory memory){
  return  Container(
    margin: EdgeInsets.only(top: 12),
    padding: EdgeInsets.all(14),
    width: double.infinity,
    height: 170,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.white),
child: Row(
  children: [
    Container(
      width: (MediaQuery.of(context).size.width -40) / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(memory.title.trim(),style: GoogleFonts.akatab(fontWeight: FontWeight.bold,color:  Colors.black,fontSize: 18),maxLines: 1,),
          Text(memory.generated.trim(),style: GoogleFonts.akatab(fontWeight: FontWeight.normal,color:  Colors.grey,fontSize: 12,),maxLines: 3,),
          Text(memory.date.substring(0,16),style: GoogleFonts.akatab(fontWeight: FontWeight.normal,color:  Colors.grey,fontSize: 15),),
        Row(children: [
          badget(Colors.orange, memory.type),
          SizedBox(width: 5,),
          badget(Colors.lightBlue,memory.state)
        ],)
        ],
      ),
    ),
   memory.imageUrl !="" ? Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(memory.imageUrl!),
          fit: BoxFit.cover,
        ),
      ),
    ):Image.asset("assets/images/welcome.png"),
  ],
),
  );
  
}

Widget badget(Color color ,String text){
  return Container(
   padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: color),
    child: Text(
      text=="musiclyrics"?"music":text,
      style: GoogleFonts.akatab(fontWeight: FontWeight.normal,color:  Colors.white,fontSize: 15),
    ),
  );
}