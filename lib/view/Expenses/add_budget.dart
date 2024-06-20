import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/common_widget/primary_button.dart';
import 'package:trackizer/common/round_textfield.dart';
import 'package:trackizer/sqldb.dart';
import 'package:trackizer/view/home/home_view.dart';
import 'package:trackizer/view/main_tab/main_tab_view.dart';

class UserPreferences {
  static String _budgetAmount = '';

  static setBudgetAmount(String amount) {
    _budgetAmount = amount;
  }

  static String getBudgetAmount() {
    return _budgetAmount;
  }
}

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({Key? key}) : super(key: key);

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final TextEditingController _budgetController = TextEditingController();
  final descriptionTextStyle = TextStyle(color: Color.fromARGB(255, 11, 163, 228));
  final SqlDb sqldb = SqlDb();
  String? email = '';

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: TColor.gray70.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                              icon: Image.asset(
                                "assets/img/back.png",
                                width: 25,
                                height: 25,
                                color: TColor.gray30,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add Budget",
                              style: TextStyle(
                                color: TColor.gray30,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Set your budget to track your expenses\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 20,
                right: 20,
              ),
              child: RoundTextField(
                
                title: "Budget Amount",
                titleAlign: TextAlign.center,
                controller: _budgetController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: PrimaryButton(
                title: "Set Budget",
                onPressed: () async {
                  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  email = sharedPreferences.getString('current_email');

                    // Log email to debug
                print('Fetched email from SharedPreferences: $email');

              if (email != null && email!.isNotEmpty) {
                  int response = await sqldb.insertData(
                        "UPDATE 'users' SET 'budget' = ${_budgetController.text.trim()} WHERE email = '$email'",
                      );
                      print(response);
                      if (response > 0) {
                        email = sharedPreferences.getString('current_email');
                        print('$email');
                        List<Map<String, dynamic>> data = await sqldb.readData("SELECT * FROM users WHERE email = '$email' ");

      // Log the data fetched from the database
      print('Data fetched from the database: $data');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainTabView(),
                          ),
                        );
                      }
                      else{
                        print("couldnt insert the budget into users accout");
                      }
                    }else {
                      print("email not found in shared preferences");
                    }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Budget: ${UserPreferences.getBudgetAmount()}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Other widgets...
          ],
        ),
      ),
    );
  }
}
