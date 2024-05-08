import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/category/edit.dart';
import 'package:fluttercourse/notes/view.dart';
import 'package:google_sign_in/google_sign_in.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  List<QueryDocumentSnapshot> datX= [];
  bool isLoading = true;
  getData()async{
    QuerySnapshot querySnapshot =await FirebaseFirestore.instance
    .collection('categories').where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .get();
    //where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid) ---> to render only catgeories for specifique user
   //await Future.delayed(Duration(seconds: 10)); to take a look on  loading 
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
        Navigator.of(context).pushNamed("addcategory");
      },child: Icon(Icons.add),),
       appBar: AppBar(title: Text("HomePage"),
       actions: [
        IconButton(onPressed: ()async{
          GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
        }, icon: Icon(Icons.exit_to_app_outlined))
       ],
       ),
      body:isLoading? Center(child: CircularProgressIndicator(),): GridView.builder(
        itemCount: datX.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 200),
        itemBuilder: (context, index) {
          return InkWell(
             onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewNotes(categoryId: datX[index].id)));
            },
            onLongPress: () {
                       AwesomeDialog(
                    context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Delete Item',
                     desc: 'choose',
                     btnOkText: "Update",
                     btnCancelText: "Delete",
                     btnCancelOnPress: ()async{
                      await FirebaseFirestore.instance .collection('categories').doc(datX[index].id).delete();
                      Navigator.of(context).pushReplacementNamed("homepage");
                     },
                     btnOkOnPress: ()async{
                       Navigator.of(context).push(MaterialPageRoute(builder:(context) => EditCategory(docId: datX[index].id, oldname: datX[index]["name"]) ));
                     }
                       ).show();
            },
            child: Card(
              child: Container(
                child: Column(
                  children: [
                    Image.asset("images/dossier.png"),
                    Text("${datX[index]["name"]}"),
                  ],
                ),
              ),
            ),
          );
        },         
     
      ),
        
    );
  }
}