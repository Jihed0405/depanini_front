import 'package:depanini/models/category.dart';
import 'package:depanini/services/categoryService.dart';
import 'package:depanini/widgets/categoryCard.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
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
    _categoryFuture =  Future.delayed(Duration(seconds: 2), ()=>_categoryService.getCategories());

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: 
      FutureBuilder<List<Category>>(
              future: _categoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return   SingleChildScrollView(
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
            ), GridView.builder(
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
                        child: CategoryCardOnload(),
                      );
                    },
                    itemCount: 9,
                  ),
        
            
            const SizedBox(height: 30),
          ],
        ),
      );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(left:32.0),
                    child: Center(
                      child: Text(
                          'Failed to load categories. Please try again later.'),
                    ),
                  );
                } else {
                  final categoryList = snapshot.data!;
       
      return SingleChildScrollView(
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
            ), GridView.builder(
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
                  ),
        
            
            const SizedBox(height: 30),
          ],
        ),
      );
                  
                }
              },
            ),
      
     
    );
  }
  
  CategoryCardOnload() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
    
        
        
      ),
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey,
                  ),
                ),
             
          SizedBox(height: 10),
           Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 100,
                    color: Colors.grey,
                  ),
                )
              
        ],
      ),
    );
  }
}
