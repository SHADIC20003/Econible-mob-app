import 'package:flutter/material.dart';
import 'package:trackizer/view/login/database_helper.dart';
import 'package:trackizer/view/login/user.dart';
import 'package:trackizer/view/login/sign_up_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _isEmailWrittenCorrect = true;

  void onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharacters = password.length >= 8;
      _hasPasswordOneNumber = numericRegex.hasMatch(password);
    });
  }

  void onEmailChanged(String email) {
    _isEmailWrittenCorrect = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(email);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 35, 35, 35), // Your desired background color
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/eco3.png",
                    width: media.width * 0.5,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  // Text(
                  //   'Sign In',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  TextField(
                    controller: txtEmail,
                    onChanged: onEmailChanged,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText:
                          _isEmailWrittenCorrect ? null : 'Invalid email',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: txtPassword,
                    onChanged: onPasswordChanged,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: _isPasswordEightCharacters
                          ? (_hasPasswordOneNumber
                              ? null
                              : 'Password must contain at least one number')
                          : 'Password must be at least 8 characters long',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        icon: Icon(_isVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    obscureText: !_isVisible,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final email = txtEmail.text.trim();
                      final password = txtPassword.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        final user = User(username: email, password: password);
                        await DatabaseHelper.addUser(user);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('User signed in successfully!')),
                        );
                        DatabaseHelper.printAllUsers();

                        // Navigate to next screen or do something else
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill in all fields')),
                        );
                      }
                    },
                    child: const Text('Sign In'),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpView(),
                        ),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
