import 'package:depanini_front/constants/color.dart';
import 'package:depanini_front/models/category.dart';
import 'package:depanini_front/services/categoryService.dart';
import 'package:depanini_front/widgets/categoryCard.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final CategoryService _categoryService = CategoryService();
  late Future<List<Category>> _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = _categoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 30,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Explore Categories",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                
                ],
              ),
            ),
        
            FutureBuilder<List<Category>>(
              future: _categoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Failed to load categories. Please try again later.'),
                  );
                } else {
                  final categoryList = snapshot.data!;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Container(constraints: BoxConstraints(maxHeight: 400,maxWidth: 500),child: CategoryCard(category: categoryList[index])),
                      );
                    },
                    itemCount: categoryList.length,
                  );
                }
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
