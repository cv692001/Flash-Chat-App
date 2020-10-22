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

String username;

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String username;
  bool showSpinner = false;
  String password;

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

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              elevation: 5.0,
              contentPadding: EdgeInsets.all(32.0),
              title: Center(
                  child: Text(
                "Login Failed !!",
                style: TextStyle(fontStyle: FontStyle.normal),
              )),
              content: Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: Text(
                  "Either email or password is incorrect",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ));
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
                          .copyWith(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: (displayHeight(context) -
                                        MediaQuery.of(context).padding.top -
                                        kToolbarHeight) *
                                    0.01953125,
                                horizontal: displayWidth(context) * 0.0555),
                          )
                          .copyWith(hintText: 'Enter your username'),
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
                    TextFormField(
                      obscureText: true,
                      validator: validatePassword,
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
                      color: Colors.lightBlueAccent,
                      text: 'Log In',
                      onpress: () async {
                        _validateInputs();

                        try {
                          final user1 = await _auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          if (user1 != null) {
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
                          setState(() {
                            showSpinner = false;
                          });
                          if (_formKey.currentState.validate()) {
                            _showAlert(context);
                          }
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
