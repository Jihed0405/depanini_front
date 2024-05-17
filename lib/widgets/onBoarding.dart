import 'package:depanini/constants/color.dart';
import 'package:depanini/constants/size.dart';
import 'package:depanini/views/home/home_view.dart';
import 'package:depanini/widgets/app.dart';
import 'package:depanini/widgets/onbordingBodyWidget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

List<OnbordingModel> onbording = [
  OnbordingModel(
      title: "Discover Artisan Gems",
      subTitle:
          "Unearth exceptional artisans tailored to your needs with ease.",
      image: "assets/images/onboarding1.jpg"),
  OnbordingModel(
      title: "Seamless Artisan Communication",
      subTitle:
          " Forge direct connections with artisans through effortless messaging.",
      image: "assets/images/onboarding1.jpg"),
  OnbordingModel(
      title: "Empower Artisans, Rate Excellence",
      subTitle:
          "Empower artisans and shape our community with your valuable feedback.",
      image: "assets/images/onboarding1.jpg"),
];

class OnbordingModel {
  String title;
  String subTitle;
  String image;
  OnbordingModel(
      {required this.title, required this.subTitle, required this.image});
}

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  int pagesLength = 3;
  final PageController _onboardController = PageController();
  bool lastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        PageView(
          onPageChanged: (value) => {
            setState(() {
              lastPage = (value == 2);
            })
          },
          controller: _onboardController,
          children: [
            onbordingBodyWidget(
                title: onbording[0].title,
                image: onbording[0].image,
                subTitle: onbording[0].subTitle),
            onbordingBodyWidget(
                title: onbording[1].title,
                image: onbording[1].image,
                subTitle: onbording[1].subTitle),
            onbordingBodyWidget(
                title: onbording[2].title,
                image: onbording[2].image,
                subTitle: onbording[2].subTitle),
          ],
        ),
        Positioned(
            bottom: 50,
            left: 175,
            child: SmoothPageIndicator(
                controller: _onboardController,
                count: pagesLength,
                effect: const SwapEffect(
                    activeDotColor: selectedPageColor,
                    dotHeight: 16,
                    dotWidth: 16,
                    dotColor: onbordingColor))),
        lastPage
            ? Positioned(
                bottom: 120,
                right: 10,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const App()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFebab01), // Set button background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Set button border radius
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 6), // Set button padding
                    child: Text(
                      "Get Started",
                      style: TextStyle(color: Colors.white, fontSize: defaultTextButtonSize),
                    ),
                  ),
                ))
            : Container()
      ],
    )));
  }
}
