import 'package:depanini/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import the package

class OnboardingBodyWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imageUrl; // Rename 'image' to 'imageUrl'
  OnboardingBodyWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.imageUrl, // Rename 'image' to 'imageUrl'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage( // Use CachedNetworkImage instead of Image.network
            imageUrl: imageUrl, // Use imageUrl instead of image
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Container(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right:20.0,left:20.0,bottom: 120.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: defaultTextSize,
                      color: Colors.white,
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
