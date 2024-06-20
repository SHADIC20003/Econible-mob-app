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
import '../login/sign_in_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSubscription = true;
  List subArr = [
    {"name": "Renting Expenses", "icon": "assets/img/rent.png", "price": "3,000"},
    {
      "name": "Food",
      "icon": "assets/img/food.png",
      "price": "1,500"
    },
    {
      "name": "Water",
      "icon": "assets/img/water.png",
      "price": "200"
    },
    {"name": "Electricity", "icon": "assets/img/electricity.png", "price": "300"}
    
  ];

  List bilArr = [
    {"name": "Renting Expenses", "date": DateTime(2023, 07, 25), "price": "3,000"},
    {
      "name": "Food",
      "date": DateTime(2023, 07, 25),
      "price": "1,500"
    },
    {
      "name": "Water",
      "date": DateTime(2023, 07, 25),
      "price": "200"
    },
    {"name": "Electricity", "date": DateTime(2023, 07, 25), "price": "15.00"}
  ];

final SqlDb sqldb = SqlDb();
  String? email = '';
  
String dbbudget = '';

@override
  void initState() {
    super.initState();
    getData(); // Call the getData function here to initially load the data
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData(); // Call getData here to refresh data when dependencies change
  }

  void getData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString('current_email');

    // Log email to debug
    print('Fetched email from SharedPreferences: $email');

    if (email != null && email!.isNotEmpty) {
      // Properly escape the email value to avoid SQL injection
      String escapedEmail = email!.replaceAll("'", "''");

      // Log the SQL query to debug
      print('SQL query: SELECT * FROM users WHERE email = \'$escapedEmail\'');

      List<Map<String, dynamic>> data = await sqldb.readData("SELECT * FROM users WHERE email = '$email' ");

      // Log the data fetched from the database
      print('Data fetched from the database: $data');

      if (data.isNotEmpty) {
        setState(() {
          dbbudget = data[0]['budget'].toString();

          
        });
      } else {
        setState(() {
          dbbudget = 'User not found';
         
        });
      }
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
                        padding:  EdgeInsets.only(bottom: media.width * 0.05),
                        width: media.width * 0.72,
                        height: media.width * 0.72,
                        child: CustomPaint(
                          painter: CustomArcPainter(end: 220, ),
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
                                          builder: (context) =>
                                              const SettingsView()));
                                },
                                icon: Image.asset("assets/img/settings.png",
                                    width: 25,
                                    height: 25,
                                    color: TColor.gray30))
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
                          width: media.width * 0.25, fit: BoxFit.contain),
                       SizedBox(
                        height: media.width * 0.07,
                      ),
                      Text(
                        dbbudget,
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: media.width * 0.055,
                      ),
                      Text(
                        "Your budget",
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
                            MaterialPageRoute(builder: (context) => const AddBudgetPage()),
                              );
                          },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: TColor.border.withOpacity(0.15),
                            ),
                            color: TColor.gray60.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Enter a new budget",
                            style: TextStyle(
                                color: TColor.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
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
                                value: "12",
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
                                value: "\E£3,000",
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
                                value: "\E£50",
                                statusColor: TColor.secondaryG,
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(15)),
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
                  )
                ],
              ),
            ),
            if (isSubscription)
              ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: subArr.length,
                  itemBuilder: (context, index) {
                    var sObj = subArr[index] as Map? ?? {};

                    return SubScriptionHomeRow(
                      sObj: sObj,
                      onPressed: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionInfoView( sObj: sObj ) ));
                      },
                    );
                  }),
            if (!isSubscription)
              ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
