import 'dart:async';

import 'package:chatSynergies/blocs/authBloc.dart';
import 'package:chatSynergies/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'file:///D:/flutter-projects/chatSynergies/lib/constants/constants.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  StreamSubscription<User> chatScreenSubscription;
  String messageText;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    chatScreenSubscription = authBloc.currentUser.listen((user) {
      if (user == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      } else {
        loggedInUser = user;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    chatScreenSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                authBloc.logOut();
              }),
        ],
        title: Text('chatSynergies'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.02)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          constraints: BoxConstraints(
                              minHeight: 50,
                              maxHeight: 120,
                              minWidth: MediaQuery.of(context).size.width - 80,
                              maxWidth: MediaQuery.of(context).size.width - 60),
                          child: TextField(
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            controller: messageTextController,
                            onChanged: (value) {
                              messageText = value;
                            },
                            keyboardType: TextInputType.multiline,
                            minLines:
                                1, //Normal textInputField will be displayed
                            maxLines: 5,
                            cursorColor: Colors.blueAccent,
                            decoration: chatTextFieldInputDecoration(),
                          ),
                        ),
                      ),
                      InkWell(
                          child: Center(
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          onTap: () {
                            String validText = messageText.trim();
                            if (validText.isNotEmpty) {
                              print('message is sending.. $messageText');
                              _firestore.collection('messages').add({
                                'text': messageText,
                                'sender': loggedInUser.email,
                                'timestamp': DateTime.now()
                                    .toUtc()
                                    .millisecondsSinceEpoch,
                              });
                            }
                            messageTextController.clear();
                            setState(() {
                              messageText = '';
                            });
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text ?? "",
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
