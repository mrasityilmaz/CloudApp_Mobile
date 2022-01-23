import 'package:cloudapp/model/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs  {
  //Shared preferences nesnesi oluşmuşsa aynı nesneyi tekrar çağırıyoruz yoksa sıfırdan oluşturuyoruz
  static late SharedPreferences prefs;
  
  //Shared prefs üzerine mail adresini kayıt ediyoruz
  static Future saveUser(User user) async {
    prefs.setString('id', user.userID!);
     prefs.setString('name', user.userName!);
      prefs.setString('surname', user.userSurname!);
       prefs.setString('mail', user.userEmail!);
      
  
  }

  static Future getUser() async
  {
    User.activeUser = User(
      isLogged: "true",
      userEmail: prefs.getString('mail'),
      userID: prefs.getString('id')
      ,userName: prefs.getString('name'),
      userSurname: prefs.getString('surname'),
      userVerify: null);
  }

  

  //Shared üzerinde kayıtlı olan bütün verileri siler
  static Future<bool> sharedClear() async {
    return prefs.clear();
  }

  //Login bilgisini tutar
  static Future<bool> login() async {
    return prefs.setBool('login', true);
  }
 


  static bool get getLogin => prefs.getBool('login') ?? false;
}