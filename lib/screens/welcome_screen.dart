import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/components/buttonWidget.dart';
import 'package:flash_chat/layout.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.066),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/logo.png'),
                        height:
                            controller.value * displayWidth(context) * 0.277,
                      ),
                    ),
                    Text(
                      'Aifly Chat',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.105,

                        // fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: (displayHeight(context) -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight) *
                    0.0937,
              ),
              Button_widget(
                color: Colors.lightBlueAccent,
                text: 'Log In ',
                onpress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              Button_widget(
                color: Colors.blueAccent,
                text: 'Register',
                onpress: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
