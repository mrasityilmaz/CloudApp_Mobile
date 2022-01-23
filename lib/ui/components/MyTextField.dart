// ignore: file_names
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  final Widget _prefixIcon;
  bool? _isPassword ;
  final bool? _suffixIconReq ;
  final String _hintText;
  final TextEditingController _controller;

   MyTextField({
    Key? key,
    required TextEditingController controller,
    required String hintText, isPassword, suffixIconReq,required prefixIcon,
  })  : _controller = controller,
        _hintText = hintText,
        _isPassword = isPassword == null ? false : true,
        _suffixIconReq = suffixIconReq,
        _prefixIcon = prefixIcon,
        super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  
 
  @override
  Widget build(BuildContext context) {
 
    return TextFormField(
      textInputAction:  TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              autofocus: true,
      obscureText: widget._isPassword != null ? widget._isPassword! : false,
      
      style: const TextStyle(fontSize: 18),
      textAlignVertical: TextAlignVertical.center,
      controller: widget._controller,
      decoration: InputDecoration(
        contentPadding:const EdgeInsets.only(top: 10),
        prefixIcon: widget._prefixIcon,
        suffixIcon:widget._suffixIconReq != null ?  InkWell(
          onTap: () {
            setState(() {
              
              widget._isPassword!   ? widget._isPassword = false : widget._isPassword = true; 
            });
          },
          
          child: const Icon(Icons.remove_red_eye,size: 30,)) : null
          ,
        hintStyle: const TextStyle(fontSize: 18),
        hintText: widget._hintText,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}