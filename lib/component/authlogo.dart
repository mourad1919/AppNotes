import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
                 child: Container(
                  width: 80,
                  height: 80,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Image.asset("images/note.jpg",height: 50,),          
                  ),
               );
  }
}