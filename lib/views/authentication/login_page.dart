import 'package:depanini/constants/color.dart';
import 'package:depanini/provider/provider.dart';
import 'package:depanini/services/authenticationApi.dart';
import 'package:depanini/widgets/onBoarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
   final AuthenticationApi _authenticationApi = AuthenticationApi();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
 print("hi frjnrjf ${ref.watch(userIdProvider)}");
  print("hi type is  ${ref.watch(userTypeProvider)}");
  print("token is ${ref.watch(userTokenProvider)}");
   return Scaffold(
     key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
               controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
               controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
             onPressed: () async {
   try {
                  final result = await _authenticationApi.signIn(_usernameController.text, _passwordController.text);
                  final jwtToken = result['token'];
                  print (jwtToken);
                  ref.read(userTokenProvider.notifier).add(jwtToken!);
                  final userType = result['userType'];
                  int userId = int.parse(result['userId']!);
                  print("the user is now $userId");
       ref.read(userIdProvider.notifier).add(userId);

                  if (userType == 'CLIENT') {
                   ref.read(userTypeProvider.notifier).add(userType!);
                   Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const onBoarding()),
                      );
                   
                  } else if (userType == 'SERVICE_PROVIDER') {
                      ref.read(userTypeProvider.notifier).add(userType!);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const onBoarding()),
                      );
                  }
                  else if (userType == 'ADMIN') {
                      ref.read(userTypeProvider.notifier).add(userType!);
                    _showErrorSnackBar(context, 'You can\'t use this app.');
                  }
                } catch (e) {
                  _showErrorSnackBar(context, 'Failed to sign in. Invalid username or password.');
                }
  },
              style: ElevatedButton.styleFrom(
                primary: selectedPageColor, // Background color
                onPrimary: Colors.white, // Text color
                padding: EdgeInsets.symmetric(vertical: 15), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Button border radius
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Image.asset(
                    'assets/images/login_icon.png', // Replace with your SVG image
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showErrorSnackBar(BuildContext context, String message) {
     final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}