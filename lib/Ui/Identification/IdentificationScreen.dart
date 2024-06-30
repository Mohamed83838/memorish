import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gemini/Api/Firebase/Authentification/FirebaseAuth.dart';
import 'package:gemini/Ui/Home/Navbar/NavBarScreen.dart';
import 'package:gemini/Ui/Identification/Component/Component.dart';
import 'package:gemini/utils/VisualTools.dart';
import 'package:hexcolor/hexcolor.dart';

class IdentificationScreen extends StatefulWidget {
  const IdentificationScreen({super.key});

  @override
  State<IdentificationScreen> createState() => _IdentificationScreenState();
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("EBF4F6"),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Let’s you in",
              style: TextStyle( fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: HexColor("252836")),),
            Image.asset('assets/images/login.png'),
            GestureDetector(
                onTap: ()async{

                  User? user = await AuthService().signInWithGoogle();
                  if(user!=null){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Navbarscreen()),
                    );
                  }else{
                    VisualTools().showCustomSnackBar(context, "An Error occured ");
                  }
                },
                child: social("Continue with google","google" ))
          ],
        ),
      ),
    );
  }
}
