import 'package:basic_chat/helper/contants.dart';
import 'package:basic_chat/services/database.dart';
import 'package:basic_chat/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.docs[index].data()["name"],
                userEmail: searchSnapshot.docs[index].data()["email"],
              );
            })
        : Container();
  }

  void initiateSearch() {
    databaseMethods
        .getUserbyUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("Kendine mesaj gönderemezsin");
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: simpleTextStyle(),
            ),
            Text(userEmail, style: simpleTextStyle())
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            createChatRoomAndStartConversation(userName: userName);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text("Mesaj gönder!"),
          ),
        )
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
          child: Column(
        children: [
          Container(
            color: Color(0x54FFFFFF),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchTextEditingController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Kullanıcı ara...",
                      hintStyle: TextStyle(color: Colors.white60),
                      border: InputBorder.none),
                )),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFF)
                        ]),
                        borderRadius: BorderRadius.circular(40)),
                    child: Image.asset("assets/images/white_search.png"),
                  ),
                )
              ],
            ),
          ),
          searchList()
        ],
      )),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
