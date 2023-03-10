library waifu_gui.flushbar_helper;

import 'package:another_flushbar/flushbar.dart';
import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';

void showInfoFlushbar({required String text, int duration = 2}) {
  Flushbar flushbar = Flushbar(
    message: text,
    icon: Icon(
      Icons.info_outline,
      size: 20.0,
      color: Theme.of(ContextHolder.currentContext).colorScheme.primary,
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
    messageColor:
        Theme.of(ContextHolder.currentContext).textTheme.bodyMedium?.color ??
            Colors.grey[900],
    backgroundColor:
        Theme.of(ContextHolder.currentContext).dialogBackgroundColor,
    leftBarIndicatorColor:
        Theme.of(ContextHolder.currentContext).colorScheme.primary,
  )..show(ContextHolder.currentContext);
}

void showErrorFlushbar({required String text, int duration = 5}) {
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
    messageColor:
        Theme.of(ContextHolder.currentContext).textTheme.bodyMedium?.color ??
            Colors.grey[900],
    backgroundColor:
        Theme.of(ContextHolder.currentContext).dialogBackgroundColor,
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
    icon: Icon(
      Icons.info_outline,
      size: 20.0,
      color: Theme.of(ContextHolder.currentContext).colorScheme.primary,
    ),
    margin: const EdgeInsets.all(8),
    mainButton: TextButton(
      onPressed: () => onPressed(),
      child: Text(
        buttonText,
        style: TextStyle(
            color: Theme.of(ContextHolder.currentContext).colorScheme.primary),
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
    messageColor:
        Theme.of(ContextHolder.currentContext).textTheme.bodyMedium?.color ??
            Colors.grey[900],
    backgroundColor:
        Theme.of(ContextHolder.currentContext).dialogBackgroundColor,
    leftBarIndicatorColor:
        Theme.of(ContextHolder.currentContext).colorScheme.primary,
  )..show(ContextHolder.currentContext);
}
