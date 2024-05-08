import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({super.key});
  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
  List<QueryDocumentSnapshot>dataU=[];
  initialData()async{
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      QuerySnapshot usersdata =  await users.where("age", isGreaterThan: 18)
        .get();
        usersdata.docs.forEach((element) { 
          dataU.add(element); 
          });
       setState(() {
         
       });

  }
  @override
  void initState(){
    initialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
       CollectionReference users = FirebaseFirestore.instance.collection('users');
       DocumentReference doc1=FirebaseFirestore.instance.collection("users").doc("1");
       DocumentReference doc2=FirebaseFirestore.instance.collection("users").doc("2");


        WriteBatch batch = FirebaseFirestore.instance.batch();
         batch.set(doc1, {
          "username":"Issam",
          "age":33,
          "money":1600,
          "phone":8588,
         });
          batch.set(doc2, {
          "username":"gass",
          "age":30,
          "money":800,
          "phone":9990,
         });
         batch.commit();

      },child: Icon(Icons.add),),
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dataU.length,
        itemBuilder: (context,i){
         return InkWell(
          onTap: () {
            DocumentReference documentReference = FirebaseFirestore.instance
           .collection('users')
           .doc(dataU[i].id);

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
           .then((value) {Navigator.of(context).pushNamedAndRemoveUntil("filterFirestore", (route) => false);});
          },
           child: Card(
            child: ListTile(
              trailing: Text("${dataU[i]["money"]}\$"),
              title: Text(dataU[i]["username"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              subtitle: Text("age ,${dataU[i]["age"]}"),
            ),
           ),
         );
        }),
      ),
    );
  }
}