import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserbyUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserbyUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async{
     return await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time" , descending: false)
        .snapshots();
  }
  getChatRooms(String userName) async{ 
    return FirebaseFirestore.instance
    .collection("ChatRooms")
    .where("users" , arrayContains: userName)
    .snapshots();
  }
}
