import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:depanini_front/routes.dart';
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
   int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
title:'Depanini',
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
home: botommbar());
  }
    SafeArea botommbar() {
    return SafeArea(
  top: false,
  child: Scaffold(
    
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.home_outlined, size: 30,color: Colors.white),
            Icon(Icons.search_outlined, size: 30,color: Colors.white),
            Icon(Icons.messenger_outline, size: 30,color: Colors.white),
            Icon(Icons.perm_identity_sharp, size: 30,color: Colors.white,),
          ],
          color: Color(0xFFebab01),
          buttonBackgroundColor: Colors.black,
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
);
  }
}

