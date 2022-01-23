import 'package:cloudapp/controller/connection_controller.dart';
import 'package:cloudapp/model/prefs.dart';

import 'package:cloudapp/model/usermodel.dart';
import 'package:cloudapp/ui/RegisterView.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'HomeView.dart';
import 'components/MyTextField.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _usernameController = TextEditingController(text: "");
    TextEditingController _passwordController = TextEditingController(text: "");
    TextEditingController _keyController = TextEditingController(text: "");

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const FadeInImage(
                  height: 250,
                  placeholder: AssetImage(
                    "assets/cloud.jpg",
                  ),
                  image: AssetImage(
                    "assets/cloud.jpg",
                  ),
                ),
                const Text("Cloud App",
                    style: TextStyle(
                      fontSize: 30,
                      color: Color.fromRGBO(13, 19, 33, 1),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextField(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Kullanıcı Adı",
                        controller: _usernameController),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        prefixIcon: const Icon(CupertinoIcons.lock_circle_fill),
                        suffixIconReq: true,
                        isPassword: true,
                        controller: _passwordController,
                        hintText: "Şifre"),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        prefixIcon: const Icon(CupertinoIcons.lock_shield_fill),
                        controller: _keyController,
                        hintText: "Key"),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const RegisterView(),
                            ),
                          );
                        },
                        child: Text(
                          "Kayıt Ol",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CupertinoButton(
                      onPressed: () async {
                        User? _user = await loginFunc(
                            _usernameController.text,
                            _passwordController.text,
                            _keyController.text,
                            context);

                        if (_user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                action: SnackBarAction(
                                    label: "Tamam", onPressed: () {}),
                                content: const Text(
                                    "Kullanıcı adı veya Şifre Hatalı \nMail Doğrulamasını Kontrol Ediniz.")),
                          );
                        } else {
                          if (_user.userVerify.toString() == "1") {
                            User.activeUser = _user;
                            SharedPrefs.saveUser(_user);
                            SharedPrefs.login();
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const HomeView(),
                                    
                              ),
                             
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Hesap doğrulama gerekli")));
                            _usernameController.clear();
                            _passwordController.clear();
                            _keyController.clear();
                          }
                        }
                      },
                      child: const Text("Giriş Yap"),
                      color: Colors.blue.shade700,
                      pressedOpacity: 0.6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
