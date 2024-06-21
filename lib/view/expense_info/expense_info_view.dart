import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackizer/common_widget/secondary_boutton.dart';
import 'package:trackizer/sqldb.dart';
import 'package:trackizer/view/main_tab/main_tab_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/item_row.dart';

class SubscriptionInfoView extends StatefulWidget {
  final Map sObj;
  const SubscriptionInfoView({super.key, required this.sObj});

  @override
  State<SubscriptionInfoView> createState() => _SubscriptionInfoViewState();
}

final SqlDb sqldb = SqlDb();
String? email = '';

Future<void> deleteExpense() async {}

class _SubscriptionInfoViewState extends State<SubscriptionInfoView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xff282833).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      height: media.width * 0.9,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: TColor.gray70,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                   Navigator.push(
                                            context,
                                          MaterialPageRoute(builder: (context) => MainTabView()),
                                              );
                                },
                                icon: Image.asset("assets/img/dorp_down.png",
                                    width: 20,
                                    height: 20,
                                    color: TColor.gray30),
                              ),
                              Text(
                                "Expense info",
                                style: TextStyle(
                                    color: TColor.gray30, fontSize: 16),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  email = sharedPreferences.getString('current_email');

                                  if (email != null && email!.isNotEmpty) {
                                    int response = await sqldb.deleteData("DELETE FROM Expense WHERE ExpenseID = ${widget.sObj["ID"]} AND userEmail = '$email'");
                                    print(response);

        
                                    // List<Map<String, dynamic>> data = await sqldb.readData("SELECT * FROM users WHERE email = '$email' ");

                                    // Log the data fetched from the database
                                    //print('Data fetched from the database: $data');

                                    Navigator.push(
                                            context,
                                          MaterialPageRoute(builder: (context) => MainTabView()),
                                              );
                                  } else {
                                    print("email not found in shared preferences");
                                  }
                                },
                                icon: Image.asset("assets/img/Trash.png",
                                    width: 25,
                                    height: 25,
                                    color: TColor.gray30),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Image.asset(
                            widget.sObj["icon"],
                            width: media.width * 0.25,
                            height: media.width * 0.25,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.sObj["name"],
                            style: TextStyle(
                                color: TColor.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "${widget.sObj["price"]}",
                            style: TextStyle(
                                color: TColor.gray30,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: TColor.border.withOpacity(0.1),
                              ),
                              color: TColor.gray60.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                ItemRow(
                                  title: "Name",
                                  value: widget.sObj["name"],
                                ),
                                ItemRow(
                                  title: "Description",
                                  value: widget.sObj["description"],
                                ),
                                ItemRow(
                                  title: "Priority",
                                  value: widget.sObj["priority"],
                                ),
                                ItemRow(
                                  title: "Date",
                                  value: widget.sObj["date"],
                                ),
                                ItemRow(
                                  title: "ExpenseID",
                                  value: widget.sObj["ID"],
                                ),
                                const ItemRow(
                                  title: "Currency",
                                  value: "EGP (\E£)",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SecondaryButton(title: "Save", onPressed: () {})
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 4, right: 4),
                height: media.width * 0.9 + 15,
                alignment: Alignment.bottomCenter,
                child: Row(children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: TColor.gray,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Expanded(
                      child: DottedBorder(
                    dashPattern: const [5, 10],
                    padding: EdgeInsets.zero,
                    strokeWidth: 1,
                    radius: const Radius.circular(16),
                    color: TColor.gray,
                    child: const SizedBox(
                      height: 0,
                    ),
                  )),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: TColor.gray,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
