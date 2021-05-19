import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.black12,
    centerTitle: true,
    title: Image.asset(
      "assets/images/lotrtext.png",
      height: 50,
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white60,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 15);
}
TextStyle mediumTextStyle(){
  return TextStyle(
    color:  Colors.white,
    fontSize: 17

  );
}
