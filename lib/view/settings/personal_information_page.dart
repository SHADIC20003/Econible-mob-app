import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackizer/sqldb.dart';
import '../../common/color_extension.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({Key? key}) : super(key: key);

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  SqlDb sqldb = SqlDb();
  String? email = '';
  String dbEmail = '';
  String dbUsername = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString('current_email');

    if (email != null && email!.isNotEmpty) {
      String escapedEmail = email!.replaceAll("'", "''");
      List<Map<String, dynamic>> data = await sqldb.readData("SELECT * FROM users WHERE email = '$escapedEmail' ");

      if (data.isNotEmpty) {
        setState(() {
          dbEmail = data[0]['email'];
          dbUsername = data[0]['userName'];
        });
      } else {
        setState(() {
          dbEmail = 'User not found';
          dbUsername = 'Unknown';
        });
      }
    } else {
      setState(() {
        dbEmail = 'No email found';
        dbUsername = 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      appBar: AppBar(
        backgroundColor: TColor.gray,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Personal Information", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              dbUsername,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Email:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              dbEmail,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
