import 'package:depanini_front/models/category.dart';
import 'package:depanini_front/services/categoryService.dart';
import 'package:depanini_front/widgets/categories.dart';
import 'package:depanini_front/widgets/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class ServiceScreen extends ConsumerStatefulWidget {
  const ServiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen> {
 final CategoryService _categoryService = CategoryService();
  late Future<List<Category>> _categoryFuture;

   @override
  void initState() {
    super.initState();
    
  }
  
   @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context), // Inherit the theme from the parent context
      child: Scaffold(
        appBar: AppBar(
          title: Text('Services',
             style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ))
        ),
        body: Services()
      ),
    );
    
    
    
    }
    }