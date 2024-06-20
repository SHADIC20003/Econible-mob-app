import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackizer/common_widget/image_button.dart';
import 'package:trackizer/common_widget/primary_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/common_widget/round_textfield.dart';

class AddSubScriptionView extends StatefulWidget {
  const AddSubScriptionView({Key? key}) : super(key: key);

  @override
  State<AddSubScriptionView> createState() => _AddSubScriptionViewState();
}

class _AddSubScriptionViewState extends State<AddSubScriptionView> {
  TextEditingController txtDescription = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List subArr = [
    {"name": "Mortgage or Rent", "icon": "assets/img/rent.png"},
    {"name": "Food", "icon": "assets/img/food.png"},
    {"name": "Transportation", "icon": "assets/img/transport.png"},
    {"name": "Utilities", "icon": "assets/img/electricity.png"},
    {"name": "Subscriptions", "icon": "assets/img/subs.png"},
    {"name": "Personal Expenses", "icon": "assets/img/clothes.png"},
    {"name": "Savings & Investments", "icon": "assets/img/savings.png"},
    {"name": "Debts or Loans", "icon": "assets/img/loans1.png"},
    {"name": "Health care", "icon": "assets/img/insurance.png"},
    {"name": "Miscellaneous expenses", "icon": "assets/img/more.png"},
  ];

  double amountVal = 5;
  DateTime selectedDate = DateTime.now();
  int selectedCategoryIndex = 0;
  int _priority = 1; // Default priority is 1

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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Add Expense\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width,
                      height: media.width * 0.6,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          viewportFraction: 0.65,
                          enlargeFactor: 0.4,
                          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                          onPageChanged: (index, reason) {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                          },
                        ),
                        itemCount: subArr.length,
                        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                          var sObj = subArr[itemIndex] as Map? ?? {};

                          return Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: itemIndex == selectedCategoryIndex ? Colors.blue : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  sObj["icon"],
                                  width: media.width * 0.4,
                                  height: media.width * 0.4,
                                  fit: BoxFit.fitHeight,
                                ),
                                const Spacer(),
                                Text(
                                  sObj["name"],
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Description TextField
            Padding(
              padding: const EdgeInsets.only(
                top: 35,
                left: 30,
                right: 30,
              ),
              child: TextFormField(
                controller: txtDescription,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white), // Set the text color
                decoration: InputDecoration(
                  filled: true,
                  fillColor: TColor.gray70.withOpacity(0.8), // Match background color
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Date Picker
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: Theme(
                // Wrap the TextFormField with a Theme widget
                data: ThemeData(
                  // Customize the text theme to set the color of the selected date text
                ),
                child: TextFormField(
                  controller: dateController,
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: TColor.gray70.withOpacity(0.8), // Match background color
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.white,
                    ),
                    hintText: 'Date',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            // Priority Button
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: PriorityButton(
                title: "Priority: ${_getPriorityText(_priority)}",
                onPressed: () {
                  _showPriorityDialog(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  _showAmountInputDialog(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: TColor.gray.withOpacity(0.8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Text(
                    "Amount: E£${amountVal.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 25,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageButton(
                    image: "assets/img/minus.png",
                    onPressed: () {
                      amountVal -= 5;

                      if (amountVal < 0) {
                        amountVal = 0;
                      }

                      setState(() {});
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      _showAmountInputDialog(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: TColor.gray.withOpacity(0.8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "E£${amountVal.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ImageButton(
                    image: "assets/img/plus.png",
                    onPressed: () {
                      amountVal += 5;

                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              child: PrimaryButton(
                title: "Add Expense",
                onPressed: _saveExpense,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAmountInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double tempAmount = amountVal;

        return AlertDialog(
          title: Text('Enter Amount'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              tempAmount = double.tryParse(value) ?? tempAmount;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  amountVal = tempAmount;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPriorityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(3, (int index) {
              return RadioListTile<int>(
                title: Text(_getPriorityText(index + 1)),
                value: index + 1,
                groupValue: _priority,
                onChanged: (int? value) {
                  setState(() {
                    _priority = value!;
                  });
                  Navigator.of(context).pop();
                },
              );
            }),
          ),
        );
      },
    );
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Low';
    }
  }

  void _saveExpense() {
    var subObj = subArr[selectedCategoryIndex] as Map? ?? {};
    print("Category Name: ${subObj["name"]}");
    print("Description: ${txtDescription.text}");
    print("Amount: E£${amountVal.toStringAsFixed(2)}");
    print("Priority: ${_getPriorityText(_priority)}");
    print("Date: ${dateController.text}");
    // Add your save logic here
  }
}

class PriorityButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  PriorityButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // iconColor: TColor.gray70.withOpacity(0.8), // Match background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: TColor.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}