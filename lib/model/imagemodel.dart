import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudapp/model/usermodel.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Images {
  static double total = 0;
  String? imageID;
  String? imageUserId;
  String? imageName;
  String? imageUrl;
  String? imageType;
  String? imageData;
  String? imageSize;
  String? imageMime;
  String? createdAt;
  String? deletedAt;

  Images(
      {this.imageID,
      this.imageUserId,
      this.imageName,
      this.imageUrl,
      this.imageType,
      this.imageData,
      this.imageSize,
      this.imageMime,
      this.createdAt,
      this.deletedAt});

  Images.fromJson(Map<String, dynamic> json) {
    imageID = json['image_id'];
    imageUserId = json['image_user_id'];
    imageName = json['image_name'];
    imageUrl = json['image_url'];
    imageType = json['image_type'];
    imageData = json['image_data'];
    imageSize = json['image_size'];
    imageMime = json['image_mime'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_id'] = imageID;
    data['image_user_id'] = imageUserId!;
    data['image_name'] = imageName!;
    data['image_url'] = imageUrl!;
    data['image_type'] = imageType!;
    data['image_data'] = imageData!;
    data['image_size'] = imageSize!;
    data['image_mime'] = imageMime!;
    data['created_at'] = createdAt!;
    data['deleted_at'] = deletedAt!;
    return data;
  }
}

Future<bool> deleteImage(String imgID) async {
  // Uygulama için oluşturulmuş api ile silinecek resmin id'sini gönderir ve silme işlemi gerçekleşir.
  var url = Uri.parse('https://pragron.com/api/image_id/$imgID');

  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    if (json.decode(response.body) != null) {
      if (response.body == "1") {
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } else {
      return Future<bool>.value(false);
    }
  } else {
    return Future<bool>.value(false);
  }
}

// Kullanıcıya ait resimleri api'den çağırır.
Future<List<Images>> getData() async {
  var id = User.activeUser!.userID;

  List<Images> imageList = [];

  var url = Uri.parse('https://pragron.com/api/user_id/$id');

  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    if (json.decode(response.body) != null) {
      for (var item in json.decode(response.body)) {
        imageList.add(Images.fromJson(item));
      }
    }
  }
  Images.total = 0;
  for (var element in imageList) {
    Images.total += (double.parse(element.imageSize.toString()) / 1000);
  }

  return imageList;
}

// Serverdaki upload için oluşturulan dosyayı çalıştırır
// İmage datayı post eder.
// Serverda bu resim yakalanıp veritabanına kaydedilir.
Future uploadImage(File? image, String name) async {
  if (image != null) {
    final uri = Uri.parse("https://pragron.com/cloudapp/imageUpload.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = name;
    request.fields['date'] = DateTime.now().toString();
    request.fields['user_id'] = User.activeUser!.userID!;

    var pic = await http.MultipartFile.fromPath("image", image.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      debugPrint("Yüklendi");
    } else {
      debugPrint("Hata");
    }
  }
}
