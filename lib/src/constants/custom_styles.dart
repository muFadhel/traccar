import 'package:flutter/material.dart';

class CustomStyles {
   static BoxShadow customShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.03),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3), // changes position of shadow
  );
}