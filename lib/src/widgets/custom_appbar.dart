import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar {
  static appBar(context, title, leading) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // <-- SEE HERE
        statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
        statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      iconTheme: const IconThemeData(
        color: Colors.black
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  static profileAppbar(context, title, leading) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // <-- SEE HERE
        statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
        statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      iconTheme: const IconThemeData(
          color: Colors.black
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_outlined),
        ),
      ],
      centerTitle: true,
    );
  }
}
