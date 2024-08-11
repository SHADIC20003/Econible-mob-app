import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackizer/sqldb.dart';
import '../../common/color_extension.dart';
import '../../common_widget/icon_item_row.dart';
import '../../view/login/sign_in_view.dart';
import 'package:trackizer/view/settings/personal_information_page.dart';
import 'package:trackizer/view/settings/help_support_page.dart';
import 'package:trackizer/view/settings/about_app_page.dart';



class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isActive = false;
  SqlDb sqldb = SqlDb();
  String? email = '';
  String dbEmail = '';
  String dbUsername = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  void navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset("assets/img/back.png",
                              width: 25, height: 25, color: TColor.gray30))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(color: TColor.gray30, fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/u1.png",
                    width: 70,
                    height: 70,
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dbUsername,
                    style: TextStyle(
                        color: TColor.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dbEmail,
                    style: TextStyle(
                        color: TColor.gray30,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: TColor.border.withOpacity(0.15),
                    ),
                    color: TColor.gray60.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Edit profile",
                    style: TextStyle(
                        color: TColor.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                      child: Text(
                        "General",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: TColor.border.withOpacity(0.1),
                        ),
                        color: TColor.gray60.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const IconItemRow(
                            title: "Security",
                            icon: "assets/img/face_id.png",
                            value: "FaceID",
                          ),
                          IconItemSwitchRow(
                            title: "iCloud Sync",
                            icon: "assets/img/icloud.png",
                            value: isActive,
                            didChange: (newVal) {
                              setState(() {
                                isActive = newVal;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "Account Settings",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: TColor.border.withOpacity(0.1),
                        ),
                        color: TColor.gray60.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text("Personal Information"),
                            leading: const Icon(Icons.person, color: Colors.white),
                            onTap: () {
                              navigateToPage(const PersonalInformationPage());
                            },
                          ),
                          ListTile(
                            title: const Text("About App"),
                            leading: const Icon(Icons.info, color: Colors.white),
                            onTap: () {
                              navigateToPage(const AboutAppPage());
                            },
                          ),
                          ListTile(
                            title: const Text("Help and Support"),
                            leading: const Icon(Icons.help, color: Colors.white),
                            onTap: () {
                              navigateToPage(const HelpSupportPage());
                            },
                          ),
                          ListTile(
                            title: const Text("Version"),
                            leading: const Icon(Icons.verified, color: Colors.white),
                            trailing: const Text("1.0.0", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: TColor.border.withOpacity(0.1),
                        ),
                        color: TColor.gray60.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                              sharedPreferences.remove('current_email');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInView(),
                                ),
                              );
                            },
                            child: const IconItemRow(
                              title: "Log Out",
                              icon: "assets/img/logout.png",
                              value: "exit",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
