import 'dart:convert';

import 'package:cloudapp/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 'https://pragron.com/api/user_email/$mail/user_key/$key/user_pass/$pass'

// Login apisine mail,password ve key verisini gönderir.
// Kullanıcı mevcut ise geriye kullanıcı bilgileri dönderir.
// Mevcut değilse null değeri dönderir.
Future<User?> loginFunc(
    String mail, String key, String pass, BuildContext con) async {
  final response = await http.get(Uri.parse(
      'https://pragron.com/api/user_email/$mail/user_key/$key/user_pass/$pass'));

  if (response.statusCode == 200) {
    if (response.body.toString() == "null") {
      return null;
    } else {
      return (User.fromJson(jsonDecode(response.body)));
    }
  } else {
    ScaffoldMessenger.of(con)
        .showSnackBar(SnackBar(content: Text(response.body)));
  }
}
