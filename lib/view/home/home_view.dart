import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/sqldb.dart';
import 'package:trackizer/view/Expenses/add_budget.dart';
import '../../common_widget/custom_arc_painter.dart';
import '../../common_widget/segment_button.dart';
import '../../common_widget/status_button.dart';
import '../../common_widget/subscription_home_row.dart';
import '../../common_widget/upcoming_bill_row.dart';
import '../settings/settings_view.dart';
import '../expense_info/expense_info_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSubscription = true;
  List<dynamic> subArr = [];
  
  final SqlDb sqldb = SqlDb();
  String? email = '';
  
  String dbbudget = '';
  String remainingBudget = '';
  String num_of_expenses = '';
  String highest_expense = '';
  String lowest_expense = '';
  double budgetPercentage = 0;

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

      List<Map<String, dynamic>> data = await sqldb.readData("SELECT * FROM users WHERE email = '$email'");

      if (data.isNotEmpty) {
        setState(() {
          dbbudget = data[0]['budget'].toString();
        });
      } else {
        setState(() {
          dbbudget = 'User not found';
        });
      }

      List<Map<String, dynamic>> expenses = await sqldb.readData("SELECT COUNT(*) AS 'expense_count' FROM Expense WHERE userEmail = '$email'");
      if (expenses.isNotEmpty) {
        setState(() {
          num_of_expenses = expenses[0]['expense_count'].toString();
        });
      } else {
        setState(() {
          num_of_expenses = 'User not found';
        });
      }
      
      List<Map<String, dynamic>> Hprice = await sqldb.readData("SELECT MAX(amount) AS 'highest' FROM Expense WHERE userEmail = '$email'");
      if (Hprice.isNotEmpty) {
        setState(() {
          highest_expense = Hprice[0]['highest'].toString();
          if (highest_expense == 'null') {
            highest_expense = '0';
          }
        });
      } else {
        setState(() {
          num_of_expenses = 'User not found';
        });
      }

      List<Map<String, dynamic>> Lprice = await sqldb.readData("SELECT MIN(amount) AS 'lowest' FROM Expense WHERE userEmail = '$email'");
      if (Lprice.isNotEmpty) {
        setState(() {
          lowest_expense = Lprice[0]['lowest'].toString();
          if (lowest_expense == 'null') {
            lowest_expense = '0';
          }
        });
      } else {
        setState(() {
          num_of_expenses = 'User not found';
        });
      }

      List<dynamic> bigData = await sqldb.readData("SELECT * FROM Expense WHERE userEmail = '$email'");
      double totalExpenses = 0;
      setState(() {
        subArr.clear();
        for (var element in bigData) {
          totalExpenses += element["amount"];
          String icon;
          switch (element["category"]) {
            case "Food":
              icon = "assets/img/food.png";
              break;
            case "Mortgage or Rent":
              icon = "assets/img/rent.png";
              break;
            case "Transportation":
              icon = "assets/img/transport.png";
              break;
            case "Utilities":
              icon = "assets/img/electricity.png";
              break;
            case "Subscriptions":
              icon = "assets/img/subs.png";
              break;
            case "Personal Expenses":
              icon = "assets/img/clothes.png";
              break;
            case "Savings & Investments":
              icon = "assets/img/savings.png";
              break;
            case "Debts or Loans":
              icon = "assets/img/loans1.png";
              break;
            case "Health care":
              icon = "assets/img/insurance.png";
              break;
            case "Miscellaneous expenses":
              icon = "assets/img/more.png";
              break;
            default:
              icon = "assets/img/more.png";
          }
          String Id = element["ExpenseID"].toString();
          subArr.add({
            "ID": Id,
            "name": element["category"],
            "priority": element["priority"],
            "date": element["date"],
            "description": element["description"],
            "createdAt": element["createdAt"],
            "icon": icon,
            "price": element["amount"]
          });
        }
        remainingBudget = (double.parse(dbbudget) - totalExpenses).toString();
        budgetPercentage = totalExpenses > 0 ? (double.parse(dbbudget) - totalExpenses) / double.parse(dbbudget) * 270 : 270;
      });
    } else {
      setState(() {
        dbbudget = 'No email found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: media.width * 1.1,
              decoration: BoxDecoration(
                color: TColor.gray70.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("assets/img/home_bg.png"),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: media.width * 0.05),
                        width: media.width * 0.72,
                        height: media.width * 0.72,
                        child: CustomPaint(
                          painter: CustomArcPainter(end: budgetPercentage),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsView()));
                              },
                              icon: Image.asset("assets/img/settings.png",
                                width: 25,
                                height: 25,
                                color: TColor.gray30)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Image.asset("assets/img/eco3.png",
                        width: media.width * 0.25,
                        fit: BoxFit.contain),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      Text(
                        remainingBudget,
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: media.width * 0.055,
                      ),
                      Text(
                        "Remaining budget",
                        style: TextStyle(
                          color: TColor.gray40,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddBudgetPage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: TColor.border.withOpacity(0.15)
                            ),
                            color: TColor.gray60.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: Text(
                            "Enter a new budget",
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: StatusButton(
                                title: "Current Expenses",
                                value: num_of_expenses,
                                statusColor: TColor.secondary,
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: StatusButton(
                                title: "Highest Expense",
                                value: "E£$highest_expense",
                                statusColor: TColor.primary10,
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: StatusButton(
                                title: "Lowest Expense",
                                value: "E£$lowest_expense",
                                statusColor: TColor.secondaryG,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentButton(
                      title: "Current Expenses",
                      isActive: isSubscription,
                      onPressed: () {
                        setState(() {
                          isSubscription = !isSubscription;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: SegmentButton(
                      title: "Upcoming bills",
                      isActive: !isSubscription,
                      onPressed: () {
                        setState(() {
                          isSubscription = !isSubscription;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isSubscription)
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: subArr.length,
                itemBuilder: (context, index) {
                  var sObj = subArr[index] as Map? ?? {};

                  return SubScriptionHomeRow(
                    sObj: sObj,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionInfoView(sObj: sObj)));
                    },
                  );
                }),
            if (!isSubscription)
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: subArr.length,
                itemBuilder: (context, index) {
                  var sObj = subArr[index] as Map? ?? {};

                  return UpcomingBillRow(
                    sObj: sObj,
                    onPressed: () {},
                  );
                }),
            const SizedBox(
              height: 110,
            ),
          ],
        ),
      ),
    );
  }
}