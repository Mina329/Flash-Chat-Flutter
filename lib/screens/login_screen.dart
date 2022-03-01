import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/Button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String pass;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email =value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Email')),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  pass = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Password')),
            SizedBox(
              height: 24.0,
            ),
            ReusableButton(
                ButtonColor: Colors.lightBlueAccent,
                onPressed: () async {
                  try {
                    final User = await _auth.signInWithEmailAndPassword(
                        email: email, password: pass);
                    if(User != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  }catch(e){

                  }
                  },
                title: 'Log In'),
          ],
        ),
      ),
    );
  }
}
