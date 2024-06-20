import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackizer/sqldb.dart';
import 'package:trackizer/view/login/sign_in_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/secondary_boutton.dart';

import 'package:trackizer/view/expenses/add_budget.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _isEmailWrittenCorrect = true;
  bool _isNameNull = false;

  bool _isVisibleNameWarn = false;
  bool _isVisibleEmailWarn = false;
  bool _isVisiblePassNumberWarn = false;
  bool _isVisiblePassCharWarn = false;

  void onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharacters = password.length >= 8;
      _hasPasswordOneNumber = numericRegex.hasMatch(password);
    });
  }

  void onEmailChanged(String email) {
    _isEmailWrittenCorrect = true;
    email = email.trim();
    setState(() {
      if (email.isEmpty) {
        _isEmailWrittenCorrect = false;
      } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email)) {
        _isEmailWrittenCorrect = false;
      }
    });
  }

  void onNameChange(String name) {
    _isNameNull = name.isEmpty;
  }

  final SqlDb sqldb = SqlDb();
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20, // Adjusted spacing above the logo
                ),
                Image.asset(
                  "assets/img/eco3.png",
                  width: media.width * 0.5,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 30, // Spacing between logo and text
                ),
                SizedBox(
                  height: 45,
                  child: Text(
                    "Please enter your email, name and password.",
                    style: TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                  ),
                ),
                SizedBox(
                  height: 20, // Spacing below the text
                ),
                TextField(
                  controller: userEmail,
                  onChanged: (email) => onEmailChanged(email),
                  cursorColor: const Color.fromARGB(255, 188, 68, 2),
                  style: TextStyle(color: TColor.white, fontSize: 14),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 107, 104, 102),
                      ),
                    ),
                    hintText: "Email (e.g., ABC@example.com)",
                    hintStyle: const TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                ),
                SizedBox(
                  height: 10, // Spacing after email field
                ),
                if (_isVisibleEmailWarn)
                  Text(
                    "Email must be prompted correctly",
                    style: TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                  ),
                SizedBox(
                  height: 20, // Spacing after email warning or between sections
                ),
                TextField(
                  controller: userName,
                  onChanged: (name) => onNameChange(name),
                  cursorColor: const Color.fromARGB(255, 188, 68, 2),
                  style: TextStyle(color: TColor.white, fontSize: 14),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 107, 104, 102),
                      ),
                    ),
                    hintText: "Name (e.g., Ahmed Alaa)",
                    hintStyle: const TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                ),
                SizedBox(
                  height: 10, // Spacing after name field
                ),
                if (_isVisibleNameWarn)
                  Text(
                    "You must enter your name.",
                    style: TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                  ),
                SizedBox(
                  height: 20, // Spacing after name warning or between sections
                ),
                TextField(
                  controller: userPassword,
                  onChanged: (password) => onPasswordChanged(password),
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
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 107, 104, 102),
                      ),
                    ),
                    hintText: "Password (e.g., ********)",
                    hintStyle: const TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                  obscureText: !_isVisible,
                ),
                SizedBox(
                  height: 10, // Spacing after password field
                ),
                if (_isVisiblePassNumberWarn)
                  Text(
                    "Password should consist of at least one digit!",
                    style: TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                  ),
                if (_isVisiblePassCharWarn)
                  Text(
                    "Password should consist of at least 8 characters!",
                    style: TextStyle(color: Color.fromARGB(255, 188, 68, 2)),
                  ),
                SizedBox(
                  height: 30, // Spacing after password warnings or between sections
                ),
                PrimaryButton(
                  title: "Get started, it's free!",
                  onPressed: () async {
                    onEmailChanged(userEmail.text);
                    onPasswordChanged(userPassword.text);
                    onNameChange(userName.text);

                    setState(() {
                      _isVisiblePassNumberWarn = !_hasPasswordOneNumber;
                      _isVisibleEmailWarn = !_isEmailWrittenCorrect;
                      _isVisiblePassCharWarn = !_isPasswordEightCharacters;
                      _isVisibleNameWarn = _isNameNull;
                    });

                    if (!_isVisiblePassNumberWarn &&
                        !_isVisibleEmailWarn &&
                        !_isVisiblePassCharWarn &&
                        !_isVisibleNameWarn) {
                      int response = await sqldb.insertData(
                        "INSERT INTO 'users' ('userName','email','password') VALUES ('${userName.text.trim()}','${userEmail.text.trim()}','${userPassword.text}')",
                      );
                      print(response);
                      if (response > 0) {
                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                        sharedPreferences.setString('current_email', userEmail.text.trim()); 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddBudgetPage(),
                          ),
                        );
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20, // Spacing after button
                ),
                Text(
                  "Already have an account?",
                  style: TextStyle(color: TColor.white, fontSize: 14),
                ),
                SizedBox(
                  height: 10, // Spacing after text
                ),
                SecondaryButton(
                  title: "Sign in",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInView(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20, // Spacing at the bottom
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
