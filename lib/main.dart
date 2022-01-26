import 'package:flutter/material.dart';
import 'package:movi_db_api2/ui/home.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.red)),
    home: MovieListView(),
    debugShowCheckedModeBanner: false,
  ));
}
