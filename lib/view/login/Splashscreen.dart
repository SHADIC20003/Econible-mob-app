import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackizer/view/login/sign_in_view.dart';
import 'package:trackizer/view/main_tab/main_tab_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? finalEmail=null;

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => finalEmail == null ? SignInView() : MainTabView(),
          ),
        );
      });
    });
  }

  Future<void> getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? obtainedEmail='';
    obtainedEmail = sharedPreferences.getString('current_email');
    setState(() {
      finalEmail = obtainedEmail;
    });
    print(finalEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Image.asset("assets/img/eco3.png"),
              radius: 100.0,
              backgroundColor: Colors.white10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CircularProgressIndicator(
                backgroundColor:  Color.fromARGB(69, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}