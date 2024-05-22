import 'package:depanini/constants/color.dart';
import 'package:depanini/constants/size.dart';
import 'package:depanini/widgets/app.dart';
import 'package:depanini/widgets/onbordingBodyWidget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

List<OnboardingModel> onboarding = [
  OnboardingModel(
    title: "Discover Artisan Gems",
    subTitle: "Unearth exceptional artisans tailored to your needs with ease.",
    imageUrl: "https://i.imgur.com/FqRO95T.jpeg", // Replace with actual URL
  ),
  OnboardingModel(
    title: "Seamless Artisan Communication",
    subTitle: "Forge direct connections with artisans through effortless messaging.",
    imageUrl: "https://i.imgur.com/IkyK6L2.jpeg", // Replace with actual URL
  ),
  OnboardingModel(
    title: "Empower Artisans, Rate Excellence",
    subTitle: "Empower artisans and shape our community with your valuable feedback.",
    imageUrl: "https://i.imgur.com/3XZIp53.jpeg", // Replace with actual URL
  ),
];

class OnboardingModel {
  String title;
  String subTitle;
  String imageUrl; // Change from 'image' to 'imageUrl'
  OnboardingModel({
    required this.title,
    required this.subTitle,
    required this.imageUrl, // Change from 'image' to 'imageUrl'
  });
}

class onBoarding extends StatefulWidget {
  const onBoarding({Key? key}) : super(key: key);

  @override
  State<onBoarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<onBoarding> {
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
                  lastPage = (value == onboarding.length - 1);
                })
              },
              controller: _onboardController,
              children: onboarding.map((item) {
                return OnboardingBodyWidget(
                  title: item.title,
                  imageUrl: item.imageUrl, // Change from 'image' to 'imageUrl'
                  subTitle: item.subTitle,
                );
              }).toList(),
            ),
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: SmoothPageIndicator(
                controller: _onboardController,
                count: onboarding.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: selectedPageColor,
                  dotHeight: 12,
                  dotWidth: 12,
                  dotColor: onbordingColor,
                ),
              ),
            ),
            if (lastPage)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 40,
                    left: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const App()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFebab01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: defaultTextButtonSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
