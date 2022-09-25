import 'package:flutter/material.dart';

Widget makeTestableWidget({Widget? child}) {
  return MaterialApp(
    home: Material(child: child),
  );
}
