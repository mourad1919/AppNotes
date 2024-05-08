import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/component/TextFormfieldAdd.dart';
import 'package:fluttercourse/notes/view.dart';

class EditNotes extends StatefulWidget {
  final String notedocid;
  final String categorydocId;
  final String value;

  const EditNotes({super.key, required this.notedocid, required this.categorydocId, required this.value});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {

  TextEditingController note=TextEditingController();
  GlobalKey<FormState> formstate=GlobalKey<FormState>();
  bool  isLoading=false;

    Editnotes() async{
        CollectionReference collectionNote = FirebaseFirestore.instance.collection('categories').doc(widget.categorydocId).collection('note');

      if(formstate.currentState!.validate()){
       try{
        isLoading=true;
        setState(() {
          
        });
          await collectionNote.doc(widget.notedocid).update({
           'note': note.text 
          });
          isLoading=false;
         Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewNotes(categoryId: widget.categorydocId)) );

       }catch(e){
        print("error $e");
       }
      }
     
    }
    @override
    void initState(){
      note.text= widget.value ;
      super.initState();
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
      appBar: AppBar(title: Text("Edit Notes"),),
      body: Form(
        key:formstate ,
        child: isLoading? Center(child: CircularProgressIndicator(),): Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: TextFormFieldAdd(hinttext: "Edit Note",mycontroller:note,validator: (p0) {
                if(p0==""){
                  Text("can't be empty");
                }
              },),
            ),
            MaterialButton(
               height: 40,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
                color: Colors.deepOrange,
              onPressed: (){
              Editnotes();
            },child: Text("Edit & Save",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),)
          ],
        )),
    );
  }
}