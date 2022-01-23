import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  static User? activeUser;

  late String? isLogged;
  late String? userID;
  late String? userEmail;
  late String? userName;
  late String? userSurname;
  late String? userVerify;

  User(
      {required this.isLogged,
      required this.userID,
      required this.userEmail,
      required this.userName,
      required this.userSurname,
      required this.userVerify});

  User.fromJson(Map<String, dynamic> json) {
    isLogged = json['isLogged'];
    userID = json['userID'];
    userEmail = json['userEmail'];
    userName = json['userName'];
    userSurname = json['userSurname'];
    userVerify = json['userVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isLogged'] = isLogged;
    data['userID'] = userID;
    data['userEmail'] = userEmail;
    data['userName'] = userName;
    data['userSurname'] = userSurname;
    data['userVerify'] = userVerify;
    return data;
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

// Doğrulama için 128 bitlik random key oluşturur.
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

// Kayıt Ol fonksiyonu
Future<User?> register(
    User user, String pass, String key, BuildContext con) async {
  String verifyCode = getRandomString(128);

  final response = await http.get(Uri.parse(
      'https://pragron.com/api/user_name/${user.userName}/user_surname/${user.userSurname}/user_email/${user.userEmail}/user_pass/$pass/user_key/$key/verify_code/$verifyCode'));

  if (response.statusCode == 200) {
    if (response.body.toString().trim() == "ex1") {
      ScaffoldMessenger.of(con).showSnackBar(const SnackBar(
          content: Text(
              "Bu Mail Adresi Veritabanımızda Kayıtlı. Lütfen Farklı Bir Mail Adresi Deneyiniz.")));
      return null;
    } else if (response.body.toString().trim() == "onay1") {
      ScaffoldMessenger.of(con).showSnackBar(const SnackBar(
          content: Text(
              "Kayıt İşleminiz Başarılı. Lütfen E-postanızı onaylayınız.")));
      return user;
    } else if (response.body.toString().trim() == "onayex1") {
      ScaffoldMessenger.of(con).showSnackBar(const SnackBar(
          content: Text(
              "Kayıt İşleminiz Başarılı. E-Posta Göndermede Bir Sorun Yaşandı. ")));
      return user;
    }
  } else {
    ScaffoldMessenger.of(con)
        .showSnackBar(SnackBar(content: Text(response.body)));
    return null;
  }
}
