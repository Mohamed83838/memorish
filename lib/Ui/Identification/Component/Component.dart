import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

Widget social(String text,String icon){

  return Container(
    width: double.infinity,

    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
    height: 50,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: HexColor("252836"),

    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/${icon}.png",width: 30,),
          SizedBox(width: 10,),
          Text(
              text,
              style: GoogleFonts.urbanist(fontSize: 17,
                  fontWeight: FontWeight.w500,color:Colors.white)

          ),
        ],
      ),
    ),
  );
}