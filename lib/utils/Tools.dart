import 'dart:io';

import 'package:image_picker/image_picker.dart';



class Tools{

  Future<File>getImage()async{
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    return file;
  }
}