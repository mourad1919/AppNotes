import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/component/TextFormfieldAdd.dart';

class EditCategory extends StatefulWidget {
  final String docId;
  final String oldname;
  const EditCategory({super.key, required this.docId, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}
//set = update
//set= add
// set can be be both add and update if the document id doesn't exist it will create the id and make the document 
//add and if the document id exist it will update it

class _EditCategoryState extends State<EditCategory> {
  TextEditingController name=TextEditingController();
  GlobalKey<FormState> formstate=GlobalKey<FormState>();
  bool  isLoading=false;
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
    editcategories() async{
      if(formstate.currentState!.validate()){
       try{
        isLoading=true;
        setState(() {
          
        });
           await categories.doc(widget.docId).update({"name":name.text});
          // await categories.doc(widget.docId).set({"name":name.text, setOption(merge:true)}); setOption merge:true keep the id of document
          // cause without it set will delete the id which make the affichage doesn't appear merge == update

          isLoading=false;
         Navigator.of(context).pushNamedAndRemoveUntil("homepage",((route) => false));

       }catch(e){
        print("error $e");
       }
      }
     
    }
    @override
    void dispose(){
      super.dispose();
      name.dispose();
      //always make dispose for textediting controller
    }



    @override
    void initState(){
      super.initState();
      name.text= widget.oldname;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category"),),
      body: Form(
        key:formstate ,
        child: isLoading? Center(child: CircularProgressIndicator(),): Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: TextFormFieldAdd(hinttext: "name",mycontroller:name,validator: (p0) {
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
              editcategories();
            },child: Text("SAVE",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),)
          ],
        )),
    );
  }
}