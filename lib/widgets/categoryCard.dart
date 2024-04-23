import 'package:depanini_front/constants/size.dart';
import 'package:depanini_front/models/category.dart';
import 'package:depanini_front/views/search/search_view.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SearchView(),
        ),
      ),
      child: Expanded(
        child: Container(
         
        
          decoration: BoxDecoration(
            
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 4.0,
                spreadRadius: .05,
              ),
            ],
          ),
          child: Expanded(
            child: Container(
            
              child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      category.imagePath,
                      height: 60,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                   // height: 100,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                       style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
