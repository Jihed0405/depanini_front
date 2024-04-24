import 'package:flutter/material.dart';

class ServiceEntity {
  final int id;
  final String name;
  late String imagePath;

  ServiceEntity({required this.id, required this.name}){
    var nameLow = name.toLowerCase() ;
  switch(nameLow){
    case 'maintenance and repair':
    imagePath='assets/images/repair-tools.png';
      break;  
    case 'housework and cleaning':
    imagePath= 'assets/images/cleaning.png' ;
      break;
      case 'moving':
      imagePath='assets/images/moving-truck.png';
        break;    
     default : 
       imagePath='assets/images/default_category.png';
  }
}

   

  factory ServiceEntity.fromJson(Map<String, dynamic> json) {
    return ServiceEntity(
      id: json['id'],
      name: json['name'],
    );
  }
}
