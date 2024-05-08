import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/component/TextFormfieldAdd.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController name=TextEditingController();
  GlobalKey<FormState> formstate=GlobalKey<FormState>();
  bool  isLoading=false;
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
    addcategories() async{
      if(formstate.currentState!.validate()){
       try{
        isLoading=true;
        setState(() {
          
        });
          DocumentReference response= await categories.add({
           'name': name.text , 'id':FirebaseAuth.instance.currentUser!.uid
          });//'id':FirebaseAuth.instance.currentUser!.uid ----> to add category to specific cuurent user
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
              addcategories();
            },child: Text("ADD",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),)
          ],
        )),
    );
  }
}