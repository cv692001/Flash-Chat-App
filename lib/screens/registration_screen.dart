import 'package:flutter/material.dart';
import 'package:flash_chat/components/buttonWidget.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/layout.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: displayWidth(context) * .066),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: (displayHeight(context) -
                            MediaQuery.of(context).padding.top -
                            kToolbarHeight) *
                        .390,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: (displayHeight(context) -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight) *
                    0.0585,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputDecoration
                    .copyWith(hintText: 'Enter your email')
                    .copyWith(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: (displayHeight(context) -
                                  MediaQuery.of(context).padding.top -
                                  kToolbarHeight) *
                              0.01953125,
                          horizontal: displayWidth(context) * 0.0555),
                    ),
              ),
              SizedBox(
                height: (displayHeight(context) -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight) *
                    0.015625,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputDecoration
                    .copyWith(hintText: 'Enter your password')
                    .copyWith(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: (displayHeight(context) -
                                  MediaQuery.of(context).padding.top -
                                  kToolbarHeight) *
                              0.01953125,
                          horizontal: displayWidth(context) * 0.0555),
                    ),
              ),
              SizedBox(
                height: (displayHeight(context) -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight) *
                    0.046875,
              ),
              Button_widget(
                color: Colors.blueAccent,
                text: 'Register',
                onpress: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  // print(email);
                  // print(password);
                  // Navigator.pushNamed(context, ChatScreen.id);
                  try {
                    final newuser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);

                    if (newuser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
