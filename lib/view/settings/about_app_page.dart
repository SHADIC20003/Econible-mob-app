import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackizer/sqldb.dart';
import '../../common/color_extension.dart';
import '../../common_widget/icon_item_row.dart';
import '../../view/login/sign_in_view.dart';
import 'package:trackizer/view/settings/personal_information_page.dart';
import 'package:trackizer/view/settings/help_support_page.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      appBar: AppBar(
        backgroundColor: TColor.gray,
        title: Text("About Econible"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Our Mission",
              style: TextStyle(
                color: TColor.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Empower individuals to achieve financial wellness through intelligent budgeting and expense management.",
              style: TextStyle(
                color: TColor.gray30,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Our Vision",
              style: TextStyle(
                color: TColor.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "To create a world where everyone can make informed financial decisions and build a secure future.",
              style: TextStyle(
                color: TColor.gray30,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Our Goals",
              style: TextStyle(
                color: TColor.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "- Provide an intuitive and user-friendly budgeting tool.\n"
              "- Foster financial education and awareness.\n"
              "- Enable users to track expenses efficiently.\n"
              "- Ensure data security and user privacy.",
              style: TextStyle(
                color: TColor.gray30,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
