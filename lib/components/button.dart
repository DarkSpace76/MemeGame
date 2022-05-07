import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mems_game/components/app_text.dart';

Widget button({required String title, Function()? onPress}) {
  return CupertinoButton(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    onPressed: onPress,
    child: Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(10)),
      child: Center(child: appText(text: title, color: Colors.white)),
    ),
  );
}

Widget skipButton(
    {required String title,
    Color borderColor = Colors.blue,
    Color textColor = Colors.black87,
    Function()? onPress}) {
  return CupertinoButton(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    onPressed: onPress,
    child: Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 3)),
      child: Center(child: appText(text: title, color: textColor)),
    ),
  );
}
