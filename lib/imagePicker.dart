import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Add this import
import 'package:path/path.dart';

class Imagepicker extends StatefulWidget {
  const Imagepicker({Key? key}) : super(key: key);

  @override
  _ImagepickerState createState() => _ImagepickerState();
}

class _ImagepickerState extends State<Imagepicker> {
  File? file;
  String? url;

  getImage() async {
    final ImagePicker picker = ImagePicker();
   // Capture a photo.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
   
   if(photo != null){
      file = File(photo.path);
     var Imagename = basename(photo.path);
     var refStorage= FirebaseStorage.instance.ref("Images").child(Imagename);
     await refStorage.putFile(file!);
      url =await refStorage.getDownloadURL();
   }

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    // Your build method implementation
    return Scaffold(
      appBar: AppBar(title: Text("Image Picker"),),
      body: Container(
        child: Column(
          children: [
            MaterialButton(onPressed: ()async{
             await getImage();

            },child: Text("add photo"),),
            if(file!=null)Container(
              padding: EdgeInsets.all(10),
              child: Image.network(url!, width: 250,height: 250,fit:BoxFit.cover,)),
          
          ],
        ),
      ),
    );
  }
}
