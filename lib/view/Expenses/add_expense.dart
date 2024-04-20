import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/common_widget/image_button.dart';
import 'package:trackizer/common_widget/primary_button.dart';
import 'package:trackizer/common_widget/round_textfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';

class AddSubScriptionView extends StatefulWidget {
  const AddSubScriptionView({Key? key}) : super(key: key);

  @override
  State<AddSubScriptionView> createState() => _AddSubScriptionViewState();
}

class _AddSubScriptionViewState extends State<AddSubScriptionView> {
  TextEditingController txtDescription = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List subArr = [
    {"name": "Renting Expenses", "icon": "assets/img/rent.png"},
    {"name": "Loans", "icon": "assets/img/loans1.png"},
    {"name": "Electricity", "icon": "assets/img/electricity.png"},
    {"name": "Water", "icon": "assets/img/water.png"},
    {"name": "Gas", "icon": "assets/img/gas.png"},
    {"name": "Insurance", "icon": "assets/img/insurance.png"},
    {"name": "Internet Access", "icon": "assets/img/wifi.png"},
    {"name": "Food", "icon": "assets/img/food.png"},
    {"name": "Vehicle", "icon": "assets/img/car.png"},
    {"name": "Transportation", "icon": "assets/img/transport.png"},
    {"name": "Medical", "icon": "assets/img/medical.png"},
    {"name": "Education", "icon": "assets/img/education.png"},
    {"name": "Entertainment", "icon": "assets/img/entertainment1.png"},
    {"name": "Clothes", "icon": "assets/img/clothes.png"},
    {"name": "Savings", "icon": "assets/img/savings.png"},
    {"name": "Software Subscriptions", "icon": "assets/img/subs.png"},
    {"name": "Travels & Trips", "icon": "assets/img/trip.png"},
    {"name": "Others", "icon": "assets/img/more.png"},
  ];

  double amountVal = 5;

  DateTime selectedDate = DateTime.now();

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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       "New",
                        //       style: TextStyle(
                        //         color: TColor.gray30,
                        //         fontSize: 16,
                        //       ),
                        //     )
                        //   ],
                        // ),
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
                          enlargeStrategy:
                              CenterPageEnlargeStrategy.zoom,
                        ),
                        itemCount: subArr.length,
                        itemBuilder: (BuildContext context,
                            int itemIndex, int pageViewIndex) {
                          var sObj = subArr[itemIndex] as Map? ?? {};

                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
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
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 20,
                right: 20,
              ),
              child: RoundTextField(
                title: "Description",
                titleAlign: TextAlign.center,
                controller: txtDescription,
              ),
            ),
            // Date Picker
           Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
  ),
  child: Theme(
    // Wrap the TextFormField with a Theme widget
    data: ThemeData(
      // Customize the text theme to set the color of the selected date text
      textTheme: TextTheme(
        subtitle1: TextStyle(color: Colors.white), // Customize the color
      ),
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
            dateController.text =
                DateFormat('dd/MM/yyyy').format(selectedDate);
          });
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: TColor.gray.withOpacity(0),
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
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
                      amountVal +=5;

                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: PrimaryButton(
                title: "Add Expense",
                onPressed: () {},
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: DottedBorder(
                  dashPattern: const [5, 4],
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(16),
                  color: TColor.border.withOpacity(0.1),
                  child: Container(
                    height: 64,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add new category ",
                          style: TextStyle(
                              color: TColor.gray30,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Image.asset(
                          "assets/img/add.png",
                          width: 12,
                          height: 12,
                          color: TColor.gray30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
             const SizedBox(
              height: 40,
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
        TextEditingController amountController = TextEditingController();
        amountController.text = amountVal.toStringAsFixed(2);

        return AlertDialog(
          backgroundColor: TColor.gray.withOpacity(0.8),
          title: Text(
            'Enter New Amount',
            style: TextStyle(color: Colors.white),
          ),
          content: TextFormField(
            controller: amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Amount',
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: TColor.gray.withOpacity(0.8),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                double newAmount = double.tryParse(amountController.text) ?? 0.0;
                setState(() {
                  amountVal = newAmount;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
