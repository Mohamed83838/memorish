import 'package:flutter/material.dart';

Widget MemoryTypeWidget(String image ,bool selected){
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.orange,width:selected ? 3 : 0),
      borderRadius: BorderRadius.circular(12),
          color: Colors.white
    ),
    child: Center(
      child: Image.asset("assets/images/${image}",width: 60,),
    ),

  );
}