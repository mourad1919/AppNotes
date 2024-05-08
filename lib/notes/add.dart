import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/component/TextFormfieldAdd.dart';
import 'package:fluttercourse/component/customButtonAuth.dart';
import 'package:fluttercourse/notes/view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class AddNotes extends StatefulWidget {
  final String docid;
  const AddNotes({super.key, required this.docid});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController note=TextEditingController();
  GlobalKey<FormState> formstate=GlobalKey<FormState>();
  bool  isLoading=false;
  File? file;
  String? url;

    Addnotes(context) async{
        CollectionReference collectionNote = FirebaseFirestore.instance.collection('categories').doc(widget.docid).collection('note');

      if(formstate.currentState!.validate()){
       try{
        isLoading=true;
        setState(() {
          
        });
          DocumentReference response= await collectionNote.add({
           'note': note.text ,
           "url":url ?? "none",
          });
          isLoading=false;
         Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewNotes(categoryId: widget.docid)) );

       }catch(e){
        print("error $e");
       }
      }
     
    }
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
    void dispose(){
      super.dispose();
      note.dispose();
      //always make dispose for textediting controller
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Notes"),),
      body: Form(
        key:formstate ,
        child: isLoading? Center(child: CircularProgressIndicator(),): Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: TextFormFieldAdd(hinttext: "Note",mycontroller:note,validator: (p0) {
                if(p0==""){
                  Text("can't be empty");
                }
              },),
            ),
            CustomButtonUpload(title: "Upload", 
            isSelected: url == null ? false: true ,onPressed: () async{
               await getImage();
            },),
            MaterialButton(
               height: 40,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
                color: Colors.deepOrange,
              onPressed: (){
              Addnotes(context);
            },child: Text("Save",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),)
          ],
        )),
    );
  }
}