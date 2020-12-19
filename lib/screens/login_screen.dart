import 'dart:async';

import 'package:chatSynergies/blocs/authBloc.dart';
import 'package:chatSynergies/components/Rounded_button.dart';
import 'package:chatSynergies/constants/constants.dart';
import 'package:chatSynergies/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email;
  String password;
  final facebookLogin = FacebookLogin();

  StreamSubscription<User> loginScreenSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginScreenSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginScreenSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Container(
                    height: 100.0,
                    child: Text(
                      '<chatSynergies/>',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    //Do something with the user input.
                    email = value;
                  },
                  decoration: kInputContainerDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kInputContainerDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    selectedColor: Colors.blueAccent,
                    selectedText: 'Login',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      final status = await authBloc.signInWithEmailAndPassword(
                          email, password);
                      if (status == false) {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have any account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()));
                        },
                        child: Text(
                          'SignUp',
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                  ],
                ),
                FlatButton(
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      final status = await authBloc.loginFacebook();
                      if (status == false) {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
                    child: Text('Continue with facebook')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
