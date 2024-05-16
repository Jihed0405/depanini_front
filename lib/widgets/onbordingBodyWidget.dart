import 'package:depanini_front/constants/color.dart';
import 'package:depanini_front/constants/size.dart';
import 'package:flutter/material.dart';

class onbordingBodyWidget extends StatelessWidget {
  String title;
  String subTitle;
  String image;
  onbordingBodyWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.image,
  }) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            image,
            fit: BoxFit.fill,
          ),
          Container(
            color: Colors.black.withOpacity(0.2), // Grey color with opacity
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
               heightFactor: 2 / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      subTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: defaultTextSize, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}