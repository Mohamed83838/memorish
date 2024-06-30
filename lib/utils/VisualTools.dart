import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class VisualTools{

  //show a custom snack bar
  void showCustomSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message),duration: Duration(seconds: 1),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //show confirmation message
  Future<bool> showConfirmationDialog(BuildContext context, String title, String content,) async {
    bool? isAccepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevents closing dialog when tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder( // Make the dialog's borders round
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: HexColor("252836"),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(fontFamily: "Urbanist",color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  content,
                  style: TextStyle(fontFamily: "Urbanist",color: Colors.grey),
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Returns false when cancelled
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontFamily: "Urbanist",color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Returns true when accepted
                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(fontFamily: "Urbanist",color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    // If isAccepted is null, it means the dialog was dismissed
    // without the user explicitly clicking on either button.
    return isAccepted ?? false; // Default value is false in case of dialog dismissal
  }}
