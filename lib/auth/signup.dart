import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/component/authlogo.dart';
import 'package:fluttercourse/component/customButtonAuth.dart';
import 'package:fluttercourse/component/customTextfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
   TextEditingController email= TextEditingController();
    TextEditingController password= TextEditingController();
    TextEditingController username = TextEditingController();
   GlobalKey<FormState> formstate =GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50,),
                 AuthLogo(),
                 Container(height: 20,),
                 Text("SignUp",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                 Container(height: 10,),
                 Text("SignUp to create an account",style: TextStyle(fontSize: 20,color: Colors.grey),),
                  Container(height: 20,),
                 Text("Username",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                   Container(height: 8,),
              
                CustomTextField(hinttext: "Username", mycontroller: username,validator: (p0) {
                  if (p0==""){
                    return "username required";
                  }
                },),
                  Container(height: 20,),
                 Text("Email",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                   Container(height: 8,),
              
                CustomTextField(hinttext: "Enter your email", mycontroller: email,validator: (p0) {
                  if(p0==""){
                    return "email required";
                  }
                },),
                  Container(height: 8,),
                 Text("Password",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                 Container(height: 8,),
                   CustomTextField(hinttext: "Enter your Password", mycontroller: password,validator: (p0) {
                     if(p0==""){
                      return "password required";
                     }
                   },),
                 Container(
                  margin: EdgeInsets.only(top: 10,bottom: 20),
                  alignment: Alignment.topRight,
                  child: Text("Forgot your password?")),
                ],
                 ),
            ),
              MaterialButton(height: 40,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
                color: Colors.deepOrange,
              onPressed:()async{
                if(formstate.currentState!.validate()){
                 try {
                 final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                 email: email.text,
                 password: password.text,
                  );
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  Navigator.of(context).pushReplacementNamed("login");
                } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                print('The password provided is too weak.');
                  AwesomeDialog(
                    context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Weak password',
                     desc: 'Try Again',
                       ).show();
                } else if (e.code == 'email-already-in-use') {
                print('The account already exists for that email.');
                  AwesomeDialog(
                    context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: ' User found already exist with that email',
                     desc: ' user found for that email',
                       ).show();
                 }
                } catch (e) {
                print(e);
                }
                }else {
                  print("Not Valid");
                }

              },child: Text("signup",style: TextStyle(fontSize: 20,))),
             
                Container(height: 10,),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("login");
                  },
                  child: Center(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: " have an account? ",style: TextStyle(fontSize: 18,color: Colors.black),),
                      TextSpan(text: "Login",style: TextStyle(fontSize: 18,color: Colors.orange),)
                    
                    ])),
                  ),
                )

          ],
        ),
      ),
    );
  }
}
