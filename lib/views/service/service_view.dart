
import 'package:depanini/provider/provider.dart';
import 'package:depanini/widgets/services.dart';
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
           centerTitle: true,
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