import 'package:depanini_front/constants/color.dart';
import 'package:depanini_front/constants/size.dart';
import 'package:flutter/material.dart';

class ProfileAccountInfoTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imageUrl;
  const ProfileAccountInfoTile(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (subTitle != '') {
      return ListTile(
        horizontalTitleGap: 0,
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 0, top: defaultSpacing / 2,right:defaultSpacing ),
          child: Image.asset(imageUrl),
        ),
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: fontHeading),
        ),
        subtitle: Text(
          subTitle,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: fontSubHeading),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right_rounded,
          color: fontSubHeading,
        ),
      );
    }
    // ignore: curly_braces_in_flow_control_structures
    else {
      return Container(
        child: Row(
          children: [
            Image.asset(imageUrl),
            Padding(
              padding: const EdgeInsets.only(
                  left: defaultSpacing, top: defaultSpacing / 2),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: fontHeading),
              ),
            ),
            const Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: fontSubHeading,
                    )))
          ],
        ),
      );
    }
  }
}