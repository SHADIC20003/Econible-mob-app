import 'package:flutter/material.dart';
import 'package:trackizer/sqldb.dart';
import 'package:trackizer/view/home/home_view.dart';
import 'package:trackizer/view/login/sign_up_view.dart';
import 'package:trackizer/view/login/social_login.dart';
import 'package:trackizer/view/login/welcome_view.dart';
import 'package:trackizer/view/main_tab/main_tab_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/secondary_boutton.dart';
import 'package:trackizer/view/expenses/set.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  bool isRemember = false;
  bool _isVisible = false;

  SqlDb sqldb = SqlDb();

  bool _isEmailWarn = false;
  bool _isPasswordWarn = false;
  bool _isPasswordCorrect = false;

  void checkPassword(String textPassword, String dbPassword) {
    _isPasswordCorrect = false;

    if (textPassword == dbPassword) {
      _isPasswordCorrect = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/img/eco3.png",
                width: media.width * 0.5,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30), // Adjusted spacing from the logo to text
              SizedBox(
                height: 45,
                child: Text(
                  "Please enter your email and password to continue.",
                  style: TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                ),
              ),
              SizedBox(height: 20), // Spacing after text
              TextField(
                controller: userEmail,
                cursorColor: const Color.fromARGB(255, 188, 68, 2),
                style: TextStyle(color: TColor.white, fontSize: 14),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 107, 104, 102)),
                  ),
                  hintText: "Enter your email (e.g., abc@gmail.com)",
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
              if (_isEmailWarn)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Wrong email address!",
                    style: TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                  ),
                ),
              SizedBox(height: 20), // Spacing after email field or warning
              TextField(
                controller: userPassword,
                cursorColor: const Color.fromARGB(255, 188, 68, 2),
                style: TextStyle(color: TColor.white, fontSize: 14),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    icon: _isVisible
                        ? const Icon(Icons.visibility, color: Color.fromARGB(255, 188, 68, 2))
                        : const Icon(Icons.visibility_off, color: Color.fromARGB(255, 188, 68, 2)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 107, 104, 102)),
                  ),
                  hintText: "Enter your password (e.g., P@ssw0rd)",
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
                obscureText: !_isVisible,
              ),
              if (_isPasswordWarn)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "The password you've entered is incorrect, please try again.",
                    style: TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                  ),
                ),
              SizedBox(height: 20), // Spacing after password field or warning
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isRemember = !isRemember;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isRemember ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                          size: 25,
                          color: Color.fromARGB(255, 188, 68, 2),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Remember me",
                          style: TextStyle(color: TColor.gray50, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot password",
                      style: TextStyle(color: TColor.gray50, fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8), // Spacing after remember me and forgot password row
              PrimaryButton(
                title: "Sign In",
                onPressed: () async {
                  _isPasswordWarn = false;
                  _isEmailWarn = false;

                  List<Map<String, dynamic>> data =
                      await sqldb.readData("SELECT * FROM users WHERE email = '${userEmail.text.trim()}'");

                  if (data.isNotEmpty) {
                    String dbPassword = data[0]['password'];
                    checkPassword(userPassword.text, dbPassword);

                    if (_isPasswordCorrect) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainTabView(),
                        ),
                      );
                    } else {
                      _isPasswordWarn = true;
                    }
                  } else {
                    _isEmailWarn = true;
                  }
                  setState(() {});
                },
              ),
              Spacer(),
              Text(
                "Don't have an account yet?",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.white, fontSize: 14),
              ),
              SizedBox(height: 20), // Spacing after "Don't have an account yet?" text
              SecondaryButton(
                title: "Sign up",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpView(),
                    ),
                  );
                },
              ),
              SizedBox(height: 20), // Spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
