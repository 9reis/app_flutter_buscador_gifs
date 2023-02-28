import 'package:app_flutter_buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'ui/home_page.dart';
//import 'package:app_flutter_buscador_gifs/ui/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    ),
  );
}
