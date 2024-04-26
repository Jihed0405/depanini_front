import 'package:depanini_front/models/category.dart';
import 'package:depanini_front/provider/provider.dart';
import 'package:depanini_front/services/categoryService.dart';
import 'package:depanini_front/widgets/categories.dart';
import 'package:depanini_front/widgets/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class ServiceView extends ConsumerStatefulWidget {
  const ServiceView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceView> {


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
          title: Text('${ref.watch(categoryNameProvider)}',
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