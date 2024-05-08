import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/notes/add.dart';
import 'package:fluttercourse/notes/edit.dart';
import 'package:google_sign_in/google_sign_in.dart';


class ViewNotes extends StatefulWidget {
  final String categoryId;
  const ViewNotes({super.key, required this.categoryId});

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}


class _ViewNotesState extends State<ViewNotes> {

  List<QueryDocumentSnapshot> datX= [];
  bool isLoading = true;
  getData()async{
    QuerySnapshot querySnapshot =await FirebaseFirestore.instance
    .collection('categories').doc(widget.categoryId).collection("note").get();
    datX.addAll(querySnapshot.docs);
    isLoading= false;
    setState(() {
      
    });
  }  
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      floatingActionButton: FloatingActionButton(
       shape: CircleBorder(),
        backgroundColor: Colors.orange,
        onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddNotes(docid: widget.categoryId)));
      },child: Icon(Icons.add),),
       appBar: AppBar(title: Text("ViewNotes"),
       actions: [
        IconButton(onPressed: ()async{
          GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
        }, icon: Icon(Icons.exit_to_app_outlined))
       ],
       ),
      body:WillPopScope(
        child: isLoading? Center(child: CircularProgressIndicator(),): GridView.builder(
        itemCount: datX.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 200),
        itemBuilder: (context, index) {
          return InkWell(
            onLongPress: () {
                       AwesomeDialog(
                    context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Delete Note',
                     desc: 'choose',
                     btnOkText: "Update",
                     btnCancelText: "Delete",
                    btnOkOnPress : ()async{
                    
                     },
                     btnCancelOnPress: ()async{
                      await FirebaseFirestore
                      .instance 
                      .collection('categories')
                      .doc(widget.categoryId)
                      .collection('note').doc(datX[index].id).delete();
                     if(datX[index]['url']!="none"){
                      FirebaseStorage.instance.refFromURL(datX[index]["url"]).delete();

                     }

                      
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewNotes(categoryId: widget.categoryId)));                     }
                       ).show();},
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context)=>EditNotes(notedocid: datX[index].id, categorydocId: widget.categoryId, value: datX[index]["note"])));
            },
              
            
            child: Card(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("${datX[index]["note"]}"),
                    SizedBox(height: 10,),
                    if(datX[index]['url']!="none")
                    Image.network(datX[index]['url'],height: 80,)
                  ],
                ),
              ),
            ),
          );
        },         
     
      ),onWillPop: (){

        Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
        return Future.value(false);

      },
      )
        
    );
  }
}