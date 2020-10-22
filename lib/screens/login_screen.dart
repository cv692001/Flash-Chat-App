import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/buttonWidget.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/layout.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  bool showSpinner = false;
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
                decoration: kInputDecoration.copyWith(
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
                color: Colors.lightBlueAccent,
                text: 'Log In',
                onpress: () async {
                  // print(email);
                  setState(() {
                    showSpinner = true;
                  });
                  // print(password);

                  try {
                    final user1 = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);

                    if (user1 != null) {
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
