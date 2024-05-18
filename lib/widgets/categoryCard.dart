
import 'package:depanini/provider/provider.dart';
import 'package:depanini/views/service/service_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryCard extends ConsumerWidget {
  final  category;
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    print("jihed${ref.watch(categoryIdProvider)}");
      print("jihed${ref.watch(categoryNameProvider)}");
    return GestureDetector(
      onTap: () {
        print ('Category tapped${category.id}');
        int  catId = category.id!;
        String categoryName = category.name!;
ref.read(categoryIdProvider.notifier).add(catId);
ref.read(categoryNameProvider.notifier).add(categoryName);
        
       Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiceView()),
              );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        
          
        
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
