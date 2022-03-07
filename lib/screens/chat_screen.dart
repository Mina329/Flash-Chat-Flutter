import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'Chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance.collection('messages');
  late String Message;
  late User logged;
  var _clear = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        logged = user;
      }
    } catch (e) {}
  }

  bool isMe(String email) {
    getCurrentUser();
    if (logged != null) {
      if (logged.email == email) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.orderBy('time').snapshots(),
              builder: (context, snashot) {
                if (snashot.hasError) {
                  return Text('Error');
                }
                if (snashot.connectionState == ConnectionState.waiting) {
                  return Text('Loading ...');
                }
                if (snashot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        reverse: true,
                        itemCount: snashot.data!.docs.length,
                        itemBuilder: (context, i) {
                          int reverseIndex = snashot.data!.docs.length - 1 - i ;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment:
                                  isMe(snashot.data!.docs[reverseIndex]['email'])
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${snashot.data!.docs[reverseIndex]['email']}',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                Material(
                                  borderRadius: isMe(
                                          snashot.data!.docs[reverseIndex]['email'])
                                      ? BorderRadius.only(
                                          bottomLeft: Radius.circular(30.0),
                                          bottomRight: Radius.circular(30.0),
                                          topLeft: Radius.circular(30.0))
                                      : BorderRadius.only(
                                          bottomLeft: Radius.circular(30.0),
                                          bottomRight: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0)),
                                  elevation: 5.0,
                                  color: isMe(snashot.data!.docs[reverseIndex]['email'])
                                      ? Colors.lightBlueAccent
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${snashot.data!.docs[reverseIndex]['text']}',
                                      style: TextStyle(
                                          color: isMe(snashot.data!.docs[reverseIndex]
                                                  ['email'])
                                              ? Colors.white
                                              : Colors.black45),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                }
                return Text('Loading ...');
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _clear,
                      onChanged: (value) {
                        Message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.add({
                        'text': Message,
                        'email': logged.email,
                        'time': FieldValue.serverTimestamp()
                      });
                      _clear.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
