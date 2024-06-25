import 'package:depanini/constants/color.dart';
import 'package:depanini/provider/provider.dart';
import 'package:depanini/services/authenticationApi.dart';
import 'package:depanini/views/authentication/sign_up_page.dart';
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
    print("hi type is ${ref.watch(userTypeProvider)}");
    print("token is ${ref.watch(userTokenProvider)}");

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: selectedPageColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Image.asset(
                'assets/person/logo.png',
                height: 150,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  try {
                    print(_passwordController.text);
                    final result = await _authenticationApi.signIn(
                        _usernameController.text, _passwordController.text);
                    final jwtToken = result['token'];
                    print(jwtToken);
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
                    } else if (userType == 'ADMIN') {
                      ref.read(userTypeProvider.notifier).add(userType!);
                      _showErrorSnackBar(context, 'You can\'t use this app.');
                    }
                  } catch (e) {
                    _showErrorSnackBar(context, 'Failed to sign in. Invalid username or password.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: selectedPageColor,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(color: selectedPageColor),
                ),
              ),
            ],
          ),
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
