import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloudapp/ui/HomeView.dart';

import 'package:cloudapp/ui/LoginView.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/prefs.dart';

// Uygulama Ana girdi noktası
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainWidget(),
  ));
}

class MainWidget extends StatefulWidget {
  const MainWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Açılış ekranındaki SplashScreen
      child: AnimatedSplashScreen.withScreenFunction(
        splash: "assets/cloud.jpg",
        splashTransition: SplashTransition.rotationTransition,
        curve: Curves.bounceInOut,
        duration: 1,
        splashIconSize: 250,
        screenFunction: () async {
          // Açılış ekranındaki animasyon tamamlandığında SharedPref
          // ile kaydettiğimiz kullanıcı verisi olup olmadığını
          // kontrol eder

          SharedPrefs.prefs = await SharedPreferences.getInstance();
          // Eğer kaydedilmiş veri varsa ve giriş tamamlandı ise Ana Ekrana devam eder.
          if (SharedPrefs.getLogin) {
            SharedPrefs.getUser();
            return const HomeView();
          } else {
            // Veri yoksa kullanıcı kayıt ekranına geri döner.
            const LoginView();
          }
          // Kaydedilmiş veri yok ise direk kullanıcı kayıt ekranına yönlendirir.
          return const LoginView();
        },
      ),
    );
  }
}
