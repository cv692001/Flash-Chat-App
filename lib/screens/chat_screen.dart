import 'package:flash_chat/layout.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  // ignore: non_constant_identifier_names
  final String username_chat;

  // ignore: non_constant_identifier_names
  const ChatScreen({Key key, this.username_chat}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(username_chat);
}

class _ChatScreenState extends State<ChatScreen> {
  // ignore: non_constant_identifier_names
  String username_chat;
  _ChatScreenState(this.username_chat);

  final _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;
  final messagingTextController = TextEditingController();

  String messageText;
  User loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(username_chat);
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();

  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  void messageStream() async {
    await for (var snapshots in _firestore.collection('messages').snapshots()) {
      for (var message in snapshots.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
          ],
          title: Text('⚡️Chat'),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  final messages = snapshots.data.docs.reversed;
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message.data()['text'];
                    final messageSender = message.data()['sender'];
                    final username_database = message.data()['username'];
                    final messageTime = message.data()['time'] as Timestamp;
                    final currentuser = loggedInUser.email;

                    final messageWidget = MessageBubble(
                      text: messageText,
                      sender: messageSender,
                      isME: currentuser == messageSender,
                      time: messageTime,
                      user: username_database,
                    );

                    messageWidgets.add(messageWidget);
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: messageWidgets,
                    ),
                  );
                },
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: messagingTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        messagingTextController.clear();

                        _firestore.collection("messages").add(
                          {
                            'text': messageText,
                            'sender': loggedInUser.email,
                            'time': FieldValue.serverTimestamp(),
                            'username': username_chat,
                          },
                        );
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle.copyWith(
                          fontSize: displayWidth(context) * 0.05,
                        ),
                      ),
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

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isME, this.time, this.user});

  final String sender;
  final String user;
  final String text;
  final bool isME;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
                isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user,
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.03333,
                  color: Colors.black54,
                ),
              ),
              Material(
                borderRadius: isME
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      )
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                elevation: 5,
                color: isME ? Colors.lightBlueAccent : Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isME ? Colors.black : Colors.black,
                      fontSize: displayWidth(context) * 0.04166,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
