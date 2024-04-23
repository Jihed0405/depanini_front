import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:depanini_front/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
//part 'main.g.dart';

// @riverpod
// String helloWorld(HelloWorldRef ref){
// return 'Hello orlds';
// }
void main() {
  runApp(ProviderScope(child: MaterialApp(home: MyApp())));
}

  class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
title:'Depanin',
theme: ThemeData(
  colorScheme:ColorScheme.fromSwatch(backgroundColor: Colors.white),
   textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          bodyLarge:TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black
          )
),),
home: SafeArea(
    top: false,
    child: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 0,
            height: 60.0,
            items: <Widget>[
              Icon(Icons.home_outlined, size: 30),
              Icon(Icons.search_outlined, size: 30),
              Icon(Icons.messenger_outline, size: 30),
              Icon(Icons.perm_identity_sharp, size: 30),
            ],
            color: Color.fromARGB(103, 80, 155, 224),
            buttonBackgroundColor: Color.fromARGB(255, 25, 155, 230),
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
            letIndexChange: (index) => true,
          ),
          body: screens[_page]),
  ));
  }}