import 'package:basic_chat/helper/helperfunctions.dart';
import 'package:basic_chat/services/auth.dart';
import 'package:basic_chat/views/chatRoomsScreen.dart';
import 'package:basic_chat/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:basic_chat/services/database.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  AuthMethods authMethods = new AuthMethods();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp()  {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text
      };

      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        //print("${val.uid}");
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                  child: CircularProgressIndicator(
                semanticsLabel: "asda",
              )),
            )
          : SingleChildScrollView(
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
                                return val.isEmpty || val.length < 6
                                    ? "Geçerli bir kullanıcı adı girin."
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              style: simpleTextStyle(),
                              decoration:
                                  textFieldInputDecoration("Kullanıcı Adı")),
                          TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Geçerli bir E-posta adresi girin.";
                              },
                              keyboardType: TextInputType.emailAddress,
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
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        signMeUp();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0xff2E8B57),
                              const Color(0xff2E8B57)
                            ]),
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "Kayıt Ol",
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
                        "Google ile Kayıt Ol",
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
                          "Hesabın zaten var mı? ",
                          style: simpleTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Giriş yap",
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
