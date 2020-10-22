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
  String username;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      setState(
        () {
          FocusScope.of(context).requestFocus(FocusNode());
          showSpinner = true;
        },
      );
      _formKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

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
              Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: (displayHeight(context) -
                              MediaQuery.of(context).padding.top -
                              kToolbarHeight) *
                          0.0585,
                    ),
                    TextFormField(
                      validator: validateUsername,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      onSaved: (value) {
                        username = value;
                      },
                      decoration: kInputDecoration
                          .copyWith(hintText: 'Enter your Username')
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
                    TextFormField(
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onSaved: (value) {
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
                    TextFormField(
                      validator: validatePassword,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onSaved: (value) {
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
                        _validateInputs();

                        // print(email);
                        // print(password);
                        // Navigator.pushNamed(context, ChatScreen.id);
                        try {
                          final newuser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);

                          if (newuser != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    username_chat: username,
                                  ),
                                ));
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
            ],
          ),
        ),
      ),
    );
  }
}

String validateUsername(String value) {
  if (value.length == 0)
    return 'Please enter a Username';
  else
    return null;
}

String validatePassword(String value) {
  if (value.length < 6)
    return 'Password must be more than 6 charater';
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}
