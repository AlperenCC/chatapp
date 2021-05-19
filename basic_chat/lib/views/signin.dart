import 'package:basic_chat/helper/helperfunctions.dart';
import 'package:basic_chat/services/auth.dart';
import 'package:basic_chat/services/database.dart';
import 'package:basic_chat/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chatRoomsScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      databaseMethods
          .getUserbyUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserEmailSharedPreference(
            snapshotUserInfo.docs[0].data()["name"]);
      });
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserEmailSharedPreference(
              emailTextEditingController.text);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/argonath.jpg"),
                fit: BoxFit.cover),
          ),
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Geçerli bir E-posta adresi girin.";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("E-Posta")),
                    TextFormField(
                        validator: (val) {
                          return val.isEmpty || val.length < 8
                              ? "Şifre en az 8 karakterden oluşmalıdır."
                              : null;
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Şifre"),
                        obscureText: true,),
                        
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Şifremi Unuttum",
                    style: simpleTextStyle(),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ]),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "Google ile Giriş Yap",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hesabın yok mu? ",
                    style: simpleTextStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Kayıt ol",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
