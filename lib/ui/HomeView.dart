import 'dart:async';
import 'dart:convert';

import 'package:cloudapp/model/imagemodel.dart';
import 'package:cloudapp/model/prefs.dart';
import 'package:cloudapp/ui/ProfileView.dart';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'LoginView.dart';
import 'components/CircularMenu.dart';

double _percent = .4;

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
                      child: const Icon(
                        Icons.security_outlined,
                        size: 80,
                      )),
                  ListTile(
                    selected: true,
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
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ProfileView(),
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
          appBar: AppBar(
            backgroundColor: Colors.pink,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text("Dosyalarım"),
          ),
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const CircularFloatingButton(),
          body: Padding(
            padding:
                const EdgeInsets.all(8.0) + const EdgeInsets.only(bottom: 20),
            child: const MyGridView(),
          ),
        ),
      ),
    );
  }
}

class PercentWidget extends StatefulWidget {
  const PercentWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PercentWidget> createState() => _PercentWidgetState();
}

class _PercentWidgetState extends State<PercentWidget> {
  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      percent: _percent,
      animateFromLastPercent: true,
      animation: true,
      progressColor: Colors.green,
      lineHeight: 30,
      center: Text(
        _percent.toString() + "/" + "1 GB",
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

class MyGridView extends StatefulWidget {
  const MyGridView({Key? key}) : super(key: key);

  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  late Future<List<Images>> _getData;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _getData = getData();

    super.initState();
  }

  Future<void> _refreshData() async {
    List<Images> data = await getData();
    setState(() {
      _getData = Future.value(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Images>>(
        future: _getData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: const [
                Text("Dosyalar Yükleniyor..."),
                SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator(),
              ],
            ));
          }
          if (snapshot.hasData) {
            return Scrollbar(
              controller: _scrollController,
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: _gridview(snapshot),
              ),
            );
          }

          return const Center(child: Text('Dosyalar Yüklenemedi !'));
        });
  }

  Widget _gridview(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: snapshot.data!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.8),
          ),
          itemBuilder: (BuildContext context, int index) {
            return RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ImageView(
                            imageID: snapshot.data![index].imageID,
                            index: index,
                            imageData: snapshot.data![index].imageData)));
              },
              child: Hero(
                tag: "logo$index",
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: MemoryImage(const Base64Codec()
                          .decode(snapshot.data![index].imageData ?? "")),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: const [
          Text("Dosyalar Yükleniyor..."),
          SizedBox(
            height: 10,
          ),
          CircularProgressIndicator(),
        ],
      ));
    }
  }
}

class ImageView extends StatelessWidget {
  final int index;
  final String? imageData;
  final String imageID;

  const ImageView(
      {Key? key,
      required this.imageData,
      required this.index,
      required this.imageID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: "logo$index",
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: MemoryImage(
                          const Base64Codec().decode(imageData ?? "")),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                     
                     
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext ctx) => FutureBuilder(
                       future: deleteImage(imageID),
                       initialData: null,
                       builder: (ctx, AsyncSnapshot snapshot)  {
                         if(snapshot.connectionState == ConnectionState.waiting)
                         {
                           return Material(
                             color: Colors.white,
                             child: Center(child: Column(
                               children: [
                                 const Spacer(),
                                 Image.memory(
                                  const Base64Codec().decode(imageData ?? "")),
                                const Text("Siliniyor"),
                                const SizedBox(height: 20,),
                               const   CircularProgressIndicator(),
                               const   Spacer(),
                               ],
                             )),
                           );
                         }
                         if(snapshot.hasData)
                         {
                           
                           return const HomeView();
                         }
                         else
                         {
                           return const HomeView();
                         }
                       },
                     )));
                    
                    
                    
                     
                            
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
