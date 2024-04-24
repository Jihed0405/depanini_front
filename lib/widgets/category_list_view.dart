import 'package:flutter/material.dart';
import 'package:depanini_front/models/category.dart';
import 'package:depanini_front/services/categoryService.dart';

class CategoryListView extends StatefulWidget {
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  final CategoryService _categoryService = CategoryService();
  late Future<List<Category>> _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = _categoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:20),
      child: Container(
        child: FutureBuilder<List<Category>>(
          future: _categoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load categories. Please try again later.'));
            } else {
              final categories = snapshot.data!;
              List<List<Category>> dividedCategories = chunk(categories, 5);
      
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: dividedCategories.map((chunk) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: chunk.map((category) {
                          return CategoryTile(category: category,
                          onTap: (){
                            print("category tapped jihed ");
                          },);
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<List<T>> chunk<T>(List<T> list, int chunkSize) {
    List<List<T>> result = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      result.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return result;
  }
}

class CategoryTile extends StatefulWidget {
  final Category category;
final VoidCallback onTap;
  const CategoryTile({Key? key, required this.category,required this.onTap,}) : super(key: key);

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      
         widget.onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: 200,
          color:  Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.category.imagePath,
                width: 42,
                height: 42,
              ),
              SizedBox(height: 10),
              Container(
                width: 75,
                child: Text(
                  widget.category.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                   softWrap: true,
                
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
