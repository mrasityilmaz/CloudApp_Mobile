import 'dart:io';

import 'package:cloudapp/model/imageModel.dart';
import 'package:cloudapp/ui/HomeView.dart';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class CircularFloatingButton extends StatefulWidget {
  const CircularFloatingButton({Key? key}) : super(key: key);

  @override
  _CircularFloatingButtonState createState() => _CircularFloatingButtonState();
}

class _CircularFloatingButtonState extends State<CircularFloatingButton> {
  File? _image;
  String name = "";
  // ignore: prefer_typing_uninitialized_variables
  var pickedImage;
  final picker = ImagePicker();
  Future choiceImage() async {
    pickedImage = (await picker.pickImage(source: ImageSource.gallery));
    setState(() {
      _image = File(pickedImage!.path);
      name = pickedImage.toString();
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext c) =>
                UploadImage(name: name, image: _image)));
  }

  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      alignment: Alignment.bottomCenter,
      toggleButtonColor: Colors.pink,
      items: [
        CircularMenuItem(
            icon: Icons.photo,
            color: Colors.green,
            onTap: () {
              choiceImage();
            }),
        CircularMenuItem(
            icon: Icons.text_fields, color: Colors.green, onTap: () {}),
      ],
    );
  }
}

class UploadImage extends StatelessWidget {
  final String name;
  File? image;

  UploadImage({Key? key, required this.name, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          SizedBox(
              height: height * .5,
              width: double.infinity,
              child: Image.file(
                image!,
                fit: BoxFit.fitHeight,
              )),
          const Spacer(
            flex: 1,
          ),
          UploadButton(
            name: name,
            image: image,
          ),
          const Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class UploadButton extends StatefulWidget {
  bool isLoad = false;
  final String name;
  final File? image;
  UploadButton({
    Key? key,
    required this.name,
    this.image,
  }) : super(key: key);

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  late final Future imageUpload;
  @override
  void initState() {
    imageUpload = uploadImage(widget.image, widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 250),
            type: PageTransitionType.bottomToTop,
            child: const HomeView(),
          ),
        );
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(50),
        ),
        child: widget.image == null
            ? null
            : FutureBuilder(
                future: imageUpload,
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return const Icon(Icons.done_all);
                },
              ),
      ),
    );
  }
}
