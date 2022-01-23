import 'package:cloudapp/model/imagemodel.dart';
import 'package:cloudapp/model/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'HomeView.dart';
import 'LoginView.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _advancedDrawerController = AdvancedDrawerController();

    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: AdvancedDrawer(
        backdropColor: Colors.blueGrey,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black87,
              blurRadius: 40,
              offset: Offset(4, 4),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: SafeArea(
          child: SizedBox(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 128.0,
                      height: 128.0,
                      margin: const EdgeInsets.only(
                        top: 24.0,
                        bottom: 64.0,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.security_outlined,size: 80,),),
                  ListTile(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const HomeView(),
                        ),
                        (route) => false,
                      );
                    },
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                  ),
                  ListTile(
                    selected: true,
                    onTap: () {
                       Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const ProfileView(),
                        ),
                        (route) => false,
                      );
                    },
                    leading: const Icon(Icons.account_circle_rounded),
                    title: const Text('Profile'),
                  ),
                
                  ListTile(
                    onTap: () {
                       SharedPrefs.sharedClear();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const LoginView(),
                        ),
                        (route) => false,
                      );
                    },
                    leading: const Icon(Icons.logout_rounded),
                    title: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const  Icon(Icons.security_outlined,size: 80,),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "CloudApp",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                 CircularPercentIndicator(
                radius: 200,
                lineWidth: 20.0,
                animation: true,
                percent: 1 -(100-Images.total)/100,
                center:  Text(
                  "Kalan Alan \n\r\r\r\r\r"+(100-Images.total).toString().substring(0,5) ,
                  style:
                      const  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                footer:const Padding(
                  padding:  EdgeInsets.only(top: 10),
                  child:   Text(
                    "Saklama Alanı",
                    style:
                         TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.purple,
              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
