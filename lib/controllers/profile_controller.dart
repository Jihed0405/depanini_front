import 'package:depanini_front/models/user.dart';
import 'package:depanini_front/services/userService.dart';

class ProfileController {
  final UserService _userService = UserService();

  Future<User> getUserById(int userId) async {
    return _userService.getUserById(userId);
  }
}