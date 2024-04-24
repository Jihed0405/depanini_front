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
    return SafeArea(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Explore Categories",
                      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
                    ),
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
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: CategoryCard(category: categoryList[index]),
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
