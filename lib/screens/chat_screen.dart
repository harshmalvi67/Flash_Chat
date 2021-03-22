import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final _cloud = FirebaseFirestore.instance;
var currentUser;

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  String messageText = '';
  File _image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  void getUser() async {
    currentUser = await _auth.currentUser;
    if (currentUser != null) {
      print(currentUser.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Color(0xff919191),
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text(
          '⚡️Chat',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xffEDEDED),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamMessage(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: kHeaderColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.emoji_emotions_outlined),
                            onPressed: () {},
                          ),
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              onChanged: (value) {
                                messageText = value;
                                //Do something with the user input.
                              },
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              imagepicker();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.attach_file),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                      onPressed: () async {
                        textEditingController.clear();
                        if (messageText.length == 0) return;
                        await _cloud.collection('messages').add({
                          'text': messageText,
                          'sender': currentUser.email,
                          'imageurl': null
                        });
                        //Implement send functionality.
                      },
                      icon: Icon(Icons.send)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void imagepicker() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      uploadImage();
    }
  }

  Future uploadImage() async {
    final storageref = _storage.ref().child('images/');
    final uploadtask = storageref.putFile(_image);
    final url = await uploadtask.whenComplete(() => uploadtask.snapshot);
    final imageurl = await url.ref.getDownloadURL();
    await _cloud
        .collection('messages')
        .add({'sender': currentUser.email, 'imageurl': imageurl, 'text': null});
  }
}

class StreamMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _cloud.collection('messages').snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          // ignore: missing_return
          return Center(
            child: Text('There is no messages'),
          );
        }
        var items = snapshots.data.docs.reversed;
        List<Widget> msgs = [];
        for (var message in items) {
          String senderEmail = message['sender'];
          //print(message['sender']);
          final item = MessageBubble(senderEmail, message['text'],
              currentUser.email == message['sender'], message['imageurl']);
          msgs.add(item);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            children: msgs,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  @override
  String sender;
  String msgText;
  String imageUrl;
  bool isMe;
  MessageBubble(this.sender, this.msgText, this.isMe, this.imageUrl);
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(isMe ? 30 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 30)),
            color: isMe ? Color(0xffDCF8C6) : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: imageUrl != null
                  ? Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.black54),
                      child: Image.network(imageUrl))
                  : Text(
                      msgText,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
