import 'package:depanini/constants/color.dart';
import 'package:depanini/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAccountInfoTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imageUrl;
  final bool load;
  const ProfileAccountInfoTile(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.imageUrl,
      required this.load});

  @override
  Widget build(BuildContext context) {
    if (subTitle != '') {
      return ListTile(
        horizontalTitleGap: 0,
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 0, top: defaultSpacing / 2, right: defaultSpacing),
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
        subtitle: Row(
          children: [
            load
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 220, // Adjust the width as needed
                      height: 14,
                      color: Colors.grey,
                    ),
                  )
                : Expanded(
                    // Use Expanded to force the specified width
                    child: Text(
                      subTitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: fontSubHeading),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right_rounded,
          color: fontSubHeading,
        ),
      );
    } else {
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
