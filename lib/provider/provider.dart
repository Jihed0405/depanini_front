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
class CategoryName extends _$CategoryName{
 @override
  String build ()=> '';
  void add(String newName) {
    state = newName; 
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


@riverpod
class ServiceName extends _$ServiceName{
 @override
  String build ()=> '';
  void add(String newName) {
    state = newName; 
  }
  
}


@riverpod
class ServiceProviderId extends _$ServiceProviderId{
 @override
  int build ()=> 3;
  void add(int newId) {
    state = newId; 
  }
  
}

@riverpod
class ServiceProviderName extends _$ServiceProviderName{
 @override
  String build ()=> '';
  void add(String newName) {
    state = newName; 
  }
  
}