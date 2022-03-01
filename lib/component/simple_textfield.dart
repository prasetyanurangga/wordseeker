import 'package:flutter/material.dart';

import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/component/simple_button.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/router/router_name.dart';


class SimpleTextField extends StatefulWidget {
  SimpleTextField({
    Key? key,
    required this.onChange,
    required this.hintText
  }) : super(key: key);


  final Function onChange;
  final String hintText;

  @override
  _SimpleTextFieldState createState() => new _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField>{

  FocusNode _textFieldFocus = FocusNode();
  TextEditingController _editingController = TextEditingController();
  Color _color = Colors.transparent;

  @override
  void initState() {
    _textFieldFocus.addListener((){
      if(_textFieldFocus.hasFocus){
        setState(() {
          _color = Color(0xFF3E5FB6).withOpacity(0.16);
        });
      }else{
        setState(() {
          _color = Colors.transparent;
        });
      }
    });
    _editingController.addListener(() {
        print(_editingController.text);

        widget.onChange(_editingController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _textFieldFocus.dispose();
    // Clean up the controller when the Widget is disposed
    _editingController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: _editingController,
      focusNode: _textFieldFocus,
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: _color,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD1DAE6).withOpacity(0.16), width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF2447A3), width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}