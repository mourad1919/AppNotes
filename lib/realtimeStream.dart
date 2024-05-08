import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFirestoreStream extends StatefulWidget {
  const FilterFirestoreStream({super.key});
  @override
  State<FilterFirestoreStream> createState() => _FilterFirestoreStreamState();
}

class _FilterFirestoreStreamState extends State<FilterFirestoreStream> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      
      body:Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder(
          stream: usersStream, builder:
         (context, AsyncSnapshot<QuerySnapshot> Lamine){
            if (Lamine.hasError) {
          return Text('Something went wrong');
        }
          if (Lamine.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return ListView.builder(
          itemCount:Lamine.data!.docs.length ,
          itemBuilder: (context,i){
           return InkWell(
            onTap: (){
            DocumentReference documentReference = FirebaseFirestore.instance
           .collection('users')
           .doc(Lamine.data!.docs[i].id);

           FirebaseFirestore.instance.runTransaction((transaction) async {
              DocumentSnapshot snapshot = await transaction.get(documentReference);
              if (snapshot.exists){
                var snapshotData=snapshot.data();
              if(snapshotData is Map<String,dynamic>){
                int money=snapshotData["money"]+100;
                transaction.update(documentReference, {"money":money});
                   }
              }
            

           })
           ;
          },
             child: Card(
              child: ListTile(
                trailing: Text("${Lamine.data!.docs[i]["money"]}\$"),
                title: Text("${Lamine.data!.docs[i]["username"]}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                subtitle: Text("age : ${Lamine.data!.docs[i]["age"]}"),
              ),
             ),
           );

          });

        } ),
      )       
        
      
    );
  }
}