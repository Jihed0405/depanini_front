import 'package:depanini_front/constants/size.dart';
import 'package:depanini_front/models/category.dart';
import 'package:depanini_front/provider/provider.dart';
import 'package:depanini_front/views/search/search_view.dart';
import 'package:depanini_front/views/service/ServiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryCard extends ConsumerWidget {
  final Category category;
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        print ('Category tapped${category.id}');
        ref.read(categoryIdProvider);
       Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiceScreen()),
              );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            ),
          ],
          border: Border.all(
            color: Colors.grey, // Border color
            width: 1, // Border width
          ),
        ),
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              category.imagePath,
              height: 60,
            ),
            SizedBox(height: 5),
            Text(
              category.name,
              maxLines: 2, // Limit to 2 lines
  overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
