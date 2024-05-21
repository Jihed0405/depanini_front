import 'package:depanini/widgets/mainLayout.dart';
import 'package:flutter/material.dart';



class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Depanini',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.white),
          textTheme: TextTheme(
              bodyMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              bodyLarge: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
        ),
        home: MainLayout());
  }
}
