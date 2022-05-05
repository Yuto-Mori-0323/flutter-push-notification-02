import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import './ui/web_view_app.dart';
import './ui/web_view_stack.dart';
import './repository/device_repository.dart';

void main() async {
  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}