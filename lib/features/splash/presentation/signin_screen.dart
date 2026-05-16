
 import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
   const SigninScreen({super.key});

   @override
   State<SigninScreen> createState() => _SigninScreenState();
 }

 class _SigninScreenState extends State<SigninScreen> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width,
         decoration: BoxDecoration(
           image: DecorationImage(image: AssetImage("assets/loginScreen.png"),
           fit: BoxFit.fill,
           )
         ),
         child: Container(),
       ),
     );
   }
 }
// Hello I am Tamim