library waifu_gui.flushbar_helper;

import 'package:another_flushbar/flushbar.dart';
import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';

void showInfoFlushbar({required String text, int duration = 2}) {
  Flushbar flushbar = Flushbar(
    message: text,
    icon: const Icon(
      Icons.info_outline,
      size: 20.0,
      color: Colors.blue,
    ),
    margin: const EdgeInsets.all(8),
    maxWidth: 350,
    duration: Duration(seconds: duration),
    boxShadows: [
      BoxShadow(
        color: Color(0x000).withOpacity(0.4),
        offset: Offset(0, 0),
        blurRadius: 3.0,
      )
    ],
    leftBarIndicatorColor: Colors.blue,
  )..show(ContextHolder.currentContext);
}

void showErrorFlushbar({required String text, int duration = 2}) {
  Flushbar flushbar = Flushbar(
    message: text,
    icon: const Icon(
      Icons.warning_amber_outlined,
      size: 20.0,
      color: Colors.red,
    ),
    margin: const EdgeInsets.all(8),
    maxWidth: 350,
    duration: Duration(seconds: duration),
    boxShadows: [
      BoxShadow(
        color: Color(0x000).withOpacity(0.4),
        offset: Offset(0, 0),
        blurRadius: 3.0,
      )
    ],
    leftBarIndicatorColor: Colors.red,
  )..show(ContextHolder.currentContext);
}

void showButtonFlushbar(
    {required String text,
    int duration = 4,
    required String buttonText,
    required void Function() onPressed}) {
  Flushbar flushbar = Flushbar(
    message: text,
    icon: const Icon(
      Icons.info_outline,
      size: 20.0,
      color: Colors.blue,
    ),
    margin: const EdgeInsets.all(8),
    mainButton: TextButton(
      onPressed: () => onPressed(),
      child: Text(
        buttonText,
        style: const TextStyle(color: Colors.blue),
      ),
    ),
    maxWidth: 500,
    duration: Duration(seconds: duration),
    boxShadows: [
      BoxShadow(
        color: Color(0x000).withOpacity(0.4),
        offset: Offset(0, 0),
        blurRadius: 3.0,
      )
    ],
    leftBarIndicatorColor: Colors.blue,
  )..show(ContextHolder.currentContext);
}
