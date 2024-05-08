import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/login.dart';
import 'package:fluttercourse/auth/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttercourse/category/addCard.dart';
import 'package:fluttercourse/cloudmessagingToken.dart';
import 'package:fluttercourse/fliter.dart';
import 'package:fluttercourse/homepage.dart';
import 'package:fluttercourse/imagePicker.dart';
import 'package:fluttercourse/notes/add.dart';
import 'package:fluttercourse/realtimeStream.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print ("=======background message");
 print (message.notification!.title);
  print (message.notification!.body);
    print (message.data);

    print ("=======background message");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 if( Platform.isAndroid){await Firebase.initializeApp(options:  FirebaseOptions(
    apiKey: "AIzaSyC78dxj1ZIE7YHAlsL04axSTSk9c6eFfto", 
    appId: "1:125183533061:android:44d47002aefc3f1ddcfc6c", 
    messagingSenderId: "125183533061", 
    projectId: "fluttercourse-51f4b",
    storageBucket: "fluttercourse-51f4b.appspot.com"
    ));}
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   @override
  void initState(){
  
    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('========User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
      super.initState();

  }
  @override
 
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.grey[50],
          titleTextStyle: TextStyle(color: Colors.orange,fontSize: 17,fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.orange),
        )
      ),
      debugShowCheckedModeBanner: false,
     home:cloudMessage(),
     //home: FilterFirestoreStream(),
     //home: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified)? HomePage():login(),
      routes: {
        "SignUp":(context) => SignUp(),
        "login":(context) => login(),
        "homepage":(context) => HomePage(),
        "addcategory":(context) =>  AddCategory(),
        "filterFirestore":(context)=> FilterFirestore(),
      },
    );
  }
}