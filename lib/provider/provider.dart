import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'provider.g.dart';
@riverpod
class CategoryId extends _$CategoryId{
 @override
  int build ()=> 3;
  void add(int newId) {
    state = newId; 
  }
  
}

@riverpod
class ServiceId extends _$ServiceId{
 @override
  int build ()=> 3;
  void add(int newId) {
    state = newId; 
  }
  
}

