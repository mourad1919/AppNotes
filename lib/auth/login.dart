import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttercourse/component/authlogo.dart';
import 'package:fluttercourse/component/customButtonAuth.dart';
import 'package:fluttercourse/component/customTextfield.dart';
import 'package:google_sign_in/google_sign_in.dart';


class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email= TextEditingController();
  TextEditingController password= TextEditingController();
  bool isLoading = false;
  
  Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if(googleUser == null){
    return;
  }

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  await FirebaseAuth.instance.signInWithCredential(credential);
  Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isLoading? Center(child: CircularProgressIndicator(),): Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 50,),
               AuthLogo(),
               Container(height: 20,),
               Text("LOGIN",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
               Container(height: 10,),
               Text("Login to use the app",style: TextStyle(fontSize: 20,color: Colors.grey),),
                Container(height: 20,),
               Text("Email",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                 Container(height: 8,),

              CustomTextField(hinttext: "Enter your email", mycontroller: email, validator: (val) {
                if (val==""){
                  return "Email required";
                }
              },),
                Container(height: 8,),
               Text("Password",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
               Container(height: 8,),
                 CustomTextField(hinttext: "Enter your Password", mycontroller: password,validator: (val){
                   if (val==""){
                  return "password required";
                }
                  
                 },),
               InkWell(
                onTap: () async {
                  if(email.text==""){
                          AwesomeDialog(
                    context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'email field empty',
                     desc: 'try agian',
                       ).show();
                    return ;
                  }
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                            AwesomeDialog(
                    context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Verify your email',
                     desc: 'password reset sent',
                       ).show();

                  } catch (e) {
                    String errorMessage = 'Unknown error occurred. Please try again later.';
                if (e is FirebaseAuthException) {
                   switch (e.code) {
                  case 'invalid-email':
                   errorMessage = 'Invalid email address format.';
                 break;
              case 'user-not-found':
                errorMessage = 'Email address not found. Please register.';
               break;
               default:
              errorMessage = 'Error: ${e.message}';
               break;
      }
    }

                   AwesomeDialog(
                    context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'email not valid',
                     desc: errorMessage,
                       ).show();
                      
                    
                  }
                 
               }, 
                 child: Container(
                  margin: EdgeInsets.only(top: 10,bottom: 20),
                  alignment: Alignment.topRight,
                  child: Text("Forgot your password?")),
               ),
              ],
               ),
              MaterialButton(height: 40,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
                color: Colors.deepOrange,onPressed: () async {
                try {
                      isLoading=true;
                      setState(() {
                        
                      });
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                     email: email.text,
                    password: password.text,
                      );
                      isLoading=false;
                      setState(() {
                        
                      });

                      if(FirebaseAuth.instance.currentUser!.emailVerified){
                       Navigator.of(context).pushNamed("homepage");
                      }else {
                           AwesomeDialog(
                    context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Verify your email',
                     desc: 'Check your mail',
                       ).show();
                      }
                      } on FirebaseAuthException catch (e) {
                          isLoading=false;
                      setState(() {
                        
                      });
                     if (e.code == 'user-not-found') {
                    AwesomeDialog(
                    context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'No User found',
                     desc: 'No user found for that email',
                       ).show();
                 } else if (e.code == 'wrong-password') {
                print('Wrong password provided for that uers.');
               AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            title: 'Wrong Password',
            desc: 'Wrong password provided for that uers',
            ).show();
  }
}
}
,child: Text("login",style: TextStyle(fontSize: 20,))),
                Container(height: 10,),
                Center(child: Text("OR LOGIN WITH")),
                Container(height: 10,),
              MaterialButton(
                height: 40,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
                color: Colors.red[700],
                onPressed: (){
                  signInWithGoogle();
                },child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("LOGIN ",style: TextStyle(fontSize: 20),),
                    Image.asset("images/g.jpg",width: 30,),
                  ],
                ),),
                Container(height: 10,),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("SignUp");
                  },
                  child: Center(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: "Don't have an account? ",style: TextStyle(fontSize: 18,color: Colors.black),),
                      TextSpan(text: "Register ",style: TextStyle(fontSize: 18,color: Colors.orange),)
                    
                    ])),
                  ),
                )

          ],
        ),
      ),
    );
  }
}