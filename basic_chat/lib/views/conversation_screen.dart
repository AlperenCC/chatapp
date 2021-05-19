import 'package:basic_chat/helper/contants.dart';
import 'package:basic_chat/services/database.dart';
import 'package:basic_chat/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
            return MessageTile(snapshot.data.docs[index].data()["message"],                        
                      snapshot.data.documents[index].data()["sendBy"] == Constants.myName);
            }) : Container();
      },
    );
  }

  sendMessages() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessagesStream = val;
      });
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
           chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Mesaj yaz...",
                          hintStyle: TextStyle(color: Colors.white60),
                          border: InputBorder.none),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessages();
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
                        child: Image.asset("assets/images/send.png"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message , this.isSendByMe );
  @override
  Widget build(BuildContext context) {
    return Container(
       padding:  EdgeInsets.only(left: isSendByMe ? 0 : 25, right: isSendByMe ? 24:0),
      margin: EdgeInsets.symmetric(vertical:8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding:  EdgeInsets.symmetric(horizontal:25, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSendByMe? [
                  const Color(0xff007EF4),
                  const Color(0xff2A75BC)
                ]:[
                  const Color(0x1AFFFFFF),
                  const Color(0x1AFFFFFF)
                ]),
                borderRadius: isSendByMe ? 
                BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
                ):
                BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)
                )
            ),
        child: Text(message ?? "ads" , style: TextStyle(
      color:  Colors.white,
      fontSize: 17

  )),
      ),
    );
  }
}
