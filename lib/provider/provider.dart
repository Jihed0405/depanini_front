import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'provider.g.dart';

@riverpod
class CategoryId extends _$CategoryId {
  @override
  int build() => 3;
  void add(int newId) {
    state = newId;
  }
}

@riverpod
class CategoryName extends _$CategoryName {
  @override
  String build() => '';
  void add(String newName) {
    state = newName;
  }
}

@riverpod
class ServiceId extends _$ServiceId {
  @override
  int build() => 3;
  void add(int newId) {
    state = newId;
  }
}

@riverpod
class ServiceName extends _$ServiceName {
  @override
  String build() => '';
  void add(String newName) {
    state = newName;
  }
}

@riverpod
class ServiceProviderId extends _$ServiceProviderId {
  @override
  int build() => 3;
  void add(int newId) {
    state = newId;
  }
}

@riverpod
class ServiceProviderName extends _$ServiceProviderName {
  @override
  String build() => '';
  void add(String newName) {
    state = newName;
  }
}

@riverpod
class bottomNavIndex extends _$bottomNavIndex {
  @override
  int build() => 0;
  void add(int newId) {
    state = newId;
  }
}

@riverpod
class UserId extends _$UserId {
  @override
  int build() => 37;
  void add(int newId) {
    print('Updating userId to $newId');
    state = newId;
  }
}
@riverpod
class userType extends _$userType {
  @override
  String build() => '';
  void add(String newType) {
    state = newType;
  }
}
@riverpod
class userToken extends _$userToken {
  @override
  String build() => '';
  void add(String newToken) {
    state = newToken;
  }
}

