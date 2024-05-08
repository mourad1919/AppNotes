import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/chat.dart';
import 'package:http/http.dart' as http;

class cloudMessage extends StatefulWidget {
  const cloudMessage({super.key});

  @override
  State<cloudMessage> createState() => _cloudMessageState();
}

class _cloudMessageState extends State<cloudMessage> {

  getToken() async{
    String? MyToken =await FirebaseMessaging.instance.getToken();
    print("========");
    print(MyToken);
  }
  MyrequestPermission()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);

if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  print('User granted permission');
} else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  print('User granted provisional permission');
} else {
  print('User declined or has not accepted permission');
}
  }
  getInitMessage()async{
     RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
        if(initialMessage !=null){
                if (initialMessage!.data['type'] == 'chat') {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>chat()));
    }
        }
 
  }

  @override
  void initState() {
    getInitMessage();
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("===============notification cliked bg");
       if (message.data['type'] == 'chat') {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>chat()));
    }
     });
    MyrequestPermission();
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  if(message.notification!=null){
        print('=========*****');
  print(message.notification!.title);
    print('Message data: ${message.notification!.body}');
    print(message.data["name"]);
      print('=========*****');
      AwesomeDialog(context: context,title:message.notification!.title ,body:Text("${message.notification!.body}"),dialogType:DialogType.info )..show();
  }

});
    getToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifcations"),),
      body: Container(
        child: MaterialButton(onPressed:()async{
           await sendMessage("mourad","alert");
           },child: Text("on send"),),
      ),
    );
  }
}

sendMessage(title,message) async {
  var headersList = {
 'Accept': '*/*',
 'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
 'Content-Type': 'application/json',
 'Authorization': 'key=AAAAHSWFIAU:APA91bF8d-uDhYgWb9wQrcnaGDGEEEiblhd9kFkF3_I-mtixLq-Cr_pXXSZ2xcH87_TsGycJOZzt4UEfpVcnqNA3JeWM9QViLCAKmTws7MGau1n5tdw7MMUfu-8EiEokBwc3ZMHtAGf3' 
};
var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

var body = {
  "to": "fJecoOg6SNWX0Sz_uRFDdD:APA91bHCZuEbqKb7MFjRUfjRx9CQzXZKyJzHvmRdTxiQ33XdhBRdUoO7x8k1r7OBmgkjFijwqkSxdEsfboO4tRF6j11PuLTjBTrViqxpc_6p_oAAv8C3W6GklgrkreNVvoJQgkEx1U0g",
  "notification": {
    "title": title,
    "body": message
  },
  "data":{"name":"wael","id":12,"type":"alert"}
};

var req = http.Request('POST', url);
req.headers.addAll(headersList);
req.body = json.encode(body);


var res = await req.send();
final resBody = await res.stream.bytesToString();

if (res.statusCode >= 200 && res.statusCode < 300) {
  print(resBody);
}
else {
  print(res.reasonPhrase);
}
}