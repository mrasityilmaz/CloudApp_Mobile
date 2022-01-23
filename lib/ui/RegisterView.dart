import 'package:cloudapp/model/usermodel.dart';
import 'package:cloudapp/ui/LoginView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'components/MyTextField.dart';

bool value = false;

// Kayıt ol ekranındaki textfieldler için oluşturduğum Controller'lar
TextEditingController _nameController = TextEditingController();
TextEditingController _surnameController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _pass1Controller = TextEditingController();
TextEditingController _pass2Controller = TextEditingController();
TextEditingController _keyController = TextEditingController();

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Cloud App- Kayıt Ol",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color.fromRGBO(13, 19, 33, 1),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "İsim",
                        controller: _nameController),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      prefixIcon: const Icon(Icons.person),
                      hintText: "Soyisim",
                      controller: _surnameController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      prefixIcon: const Icon(Icons.email),
                      hintText: "E-Mail",
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      prefixIcon: const Icon(CupertinoIcons.lock_circle_fill),
                      hintText: "Şifre",
                      controller: _pass1Controller,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      prefixIcon: const Icon(CupertinoIcons.lock_circle_fill),
                      hintText: "Şifre Tekrar",
                      controller: _pass2Controller,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      prefixIcon: const Icon(CupertinoIcons.lock_shield_fill),
                      hintText: "Güvenlik Anahtarı*",
                      controller: _keyController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CheckBoxAndCupertinoButton(height: height),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CheckBoxAndCupertinoButton extends StatefulWidget {
  final double _height;
  const CheckBoxAndCupertinoButton({
    Key? key,
    required height,
  })  : _height = height,
        super(key: key);

  @override
  State<CheckBoxAndCupertinoButton> createState() =>
      _CheckBoxAndCupertinoButtonState();
}

class _CheckBoxAndCupertinoButtonState
    extends State<CheckBoxAndCupertinoButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Checkbox(
                splashRadius: 1,
                value: value,
                onChanged: (state) {
                  setState(() {
                    value = state!;
                  });
                }),
            InkWell(
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext con) => Material(
                          child: SizedBox(
                              width: double.infinity,
                              height: widget._height * .865,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "Gizlilik Politikası",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Wrap(
                                        children: [
                                          Text(
                                            textm,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ))));
                },
                child: const Text(
                  "Gizlilik Politikasını Okudum ve Kabul Ediyorum.",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                  ),
                )),
          ],
        ),
        CupertinoButton(
          disabledColor: Colors.black26,
          onPressed: value
              ? () async {
                  if (_pass1Controller.text.trim().length < 6 ||
                      _keyController.text.trim().length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Şifre veya Keyinizin 6 karakterden uzun olmasına dikkat ediniz.")));
                  } else if (_pass1Controller.text.trim() !=
                      _pass2Controller.text.trim()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Şifreler Uyuşmuyor")));
                  } else {
                    User newUser = User(
                      isLogged: "false",
                      userID: '',
                      userEmail: _emailController.text.trim(),
                      userName: _nameController.text.trim(),
                      userSurname: _surnameController.text.trim(),
                      userVerify: "",
                    );

                    User? isRegistered = await register(
                        newUser,
                        _pass1Controller.text.trim(),
                        _keyController.text.trim(),
                        context);

                    if (isRegistered != null) {
                      await Navigator.push(
                        context,
                        PageTransition(
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 180),
                          type: PageTransitionType.fade,
                          child: const LoginView(),
                        ),
                      );
                    }
                  }
                }
              : null,
          child: const Text("Kayıt Ol"),
          color: Colors.black,
          pressedOpacity: 0.6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}

String textm =
    """İşbu ‘’Gizlilik Sözleşmesi’’ (bundan böyle “Sözleşme” olarak anılacaktır……………………………..
adresinde mukim ………………………… (bundan böyle “…………………..” olarak anılacaktır) ile
diğer tarafta ……………….. adresinde mukim ………………………. (bundan böyle ‘’FİRMA” olarak
anılacaktır) arasında akdedilmiştir.
……….. ve FİRMA bundan böyle ayrı ayrı “Taraf” ve birlikte “Taraflar” olarak anılabilecektir.
1. Amaç:
Taraflar, ihtiyaç duyulması halinde kullanılmak üzere taraflarca yapılacak tüm görüşmeler
sırasında birbirlerine yapacakları açıklamalarda kendilerine ait bir takım Gizli Bilgileri birbirleri ile
paylaşabileceklerdir.
İşbu Sözleşme, Tarafların görüşmeleri süresince yapacakları çalışmalarda birbirlerine açacakları
gizlilik dereceli bilgilerin mübadele usulünün belirlenmesi ve bir tarafça diğer tarafa açılan Gizli
Bilgilerin korunmasına yönelik olarak hak ve yükümlülüklerin belirlenmesi amacıyla düzenlenmiştir.
İşbu Sözleşme, Tarafları, herhangi bir doküman ve/veya bilgiyi birbirlerine açma/verme
yükümlüğüne sokmaz.
2. Gizli Bilginin Tanımı ve Kapsamı:
İşbu sözleşmenin 1. maddesinde belirtilen amaç doğrultusunda Taraflar arasında mübadele
edilebilecek “Gizli Bilgi”, bunların sahibi olan Taraf’ın, ticari sır mahiyetinde ve/veya mülkiyeti
altındaki bilgilerinin tamamı anlamına gelir; bunlara herhangi bir sınırlama olmaksızın, tasarım
bilgileri, teknik bilgiler, ticari sırlar, fikir ve buluşlar, projeler, çizimler, modeller, yazılım
programları, algoritmalar, yazılım modülleri, program kaynak kodları, teknik özellikler, ürün plan
ve teknolojileri, yazılım kullanıcı kitapçıkları, pazarlama bilgileri, müşteri listeleri, tahmin ve
değerlendirmeler, finansal raporlar, kontrat hükümleri, kayıtlar ve söz konusu Taraf’ın işiyle ilgili
tüm bilgi ve malzemeler, …………….’in kendisine, hissedarlarına, iştiraklerine, ruhsat vermiş
olduğu diğer kişilere, müşterilerine ve danışmanlarına ilişkin her türlü ürün, mal ve hizmet, bunları
elde etmede kullanılan yöntem, ticari sır, her türlü formül, know-how, patent, buluş, dizayn,
müşteri listeleri, bütçe, iş geliştirme, pazarlama ve fiyatlama plan ve stratejileri ve benzeri her
türlü bilgiyi kapsar.
Sözlü, görsel, örnekler veya modeller ile açıklanan (yazılı olmayan) ve gizlilik derecesi olan bilgiler
ve/veya bilgiyi açan Tarafça diğer Tarafa verilebilecek projelerin, çizimlerin, cihazların veya
komponentlerinin incelenmesi, test edilmesi ve benzeri yöntemlerin kullanılması sureti ile
edinilebilecek gizlilik dereceli bilgiler de bundan böyle “Gizli Bilgi” olarak anılacaktır ve bu Sözleşme
kapsamında işlem görecektir.
Sözlü olarak açılan bilgi, bu bilgiyi açan Tarafça bilgiyi açtığı zaman, sözlü olarak verilen bu bilginin
Gizli Bilgi olduğunu açıkça belirttiği ve bilgiyi açtıktan sonraki 10 (on) gün içinde diğer Taraf’a yazılı
olarak bildirdiği takdirde, sözlü şekilde diğer tarafa verilen bilgi Gizli Bilgi olarak işlem görecektir.
Bilgiler; Gizli Bilgi gibi korunup, kullanılacaktır""";
