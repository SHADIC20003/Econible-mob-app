import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:trackizer/common/color_extension.dart';

class SpendingBudgetsView extends StatefulWidget {
  @override
  _SpendingBudgetsViewState createState() => _SpendingBudgetsViewState();
}

class _SpendingBudgetsViewState extends State<SpendingBudgetsView> {
  final List<Map<String, dynamic>> budgetCategories = [
    {"name": "Mortgage or Rent", "icon": "assets/img/rent.png", "priority": "medium", "percentage": 40.0},
    {"name": "Food", "icon": "assets/img/food.png", "priority": "high", "percentage": 15.0},
    {"name": "Transportation", "icon": "assets/img/transport.png", "priority": "medium", "percentage": 6.0},
    {"name": "Utilities", "icon": "assets/img/electricity.png", "priority": "medium", "percentage": 5.0},
    {"name": "Subscriptions", "icon": "assets/img/subs.png", "priority": "medium", "percentage": 2.0},
    {"name": "Personal Expenses", "icon": "assets/img/clothes.png", "priority": "low", "percentage": 3.0},
    {"name": "Savings & Investments", "icon": "assets/img/savings.png", "priority": "high", "percentage": 10.0},
    {"name": "Debts or Loans", "icon": "assets/img/loans1.png", "priority": "medium", "percentage": 8.0},
    {"name": "Health care", "icon": "assets/img/medical.png", "priority": "high", "percentage": 9.0},
    {"name": "Miscellaneous expenses", "icon": "assets/img/more.png", "priority": "low", "percentage": 1.0},
  ];

  final Random _random = Random();
  bool _showPieChart = true;
  final List<Color> _categoryColors = [];

  @override
  void initState() {
    super.initState();
    _generateCategoryColors();
  }

  void _generateCategoryColors() {
    for (var i = 0; i < budgetCategories.length; i++) {
      _categoryColors.add(Color(_random.nextInt(0xFFFFFF)).withOpacity(1.0));
    }
  }

  void _toggleView() {
    setState(() {
      _showPieChart = !_showPieChart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Color.fromARGB(80, 80, 80, 75),
      appBar: AppBar(
        title: Text('Insights Page') , backgroundColor: TColor.gray80,
        actions: [
          IconButton(
            icon: Icon(_showPieChart ? Icons.list : Icons.pie_chart),
            onPressed: _toggleView,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 85.0),
        child: _showPieChart ? _buildPieChartPage() : _buildCategoriesPage(),
      ),
    );
  }

  Widget _buildPieChartPage() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: List.generate(
                    budgetCategories.length,
                    (index) {
                      final category = budgetCategories[index];
                      return PieChartSectionData(
                        value: category['percentage'],
                        title: '${category['percentage'].toStringAsFixed(0)}%',
                        color: _categoryColors[index],
                        radius: 120,
                        titleStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(enabled: true),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(
              budgetCategories.length,
              (index) {
                final category = budgetCategories[index];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: _categoryColors[index],
                    ),
                    SizedBox(width: 8.0),
                    Text(category['name']),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesPage() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: budgetCategories.length,
      itemBuilder: (context, index) {
        final category = budgetCategories[index];
        return ListTile(
          leading: Container(
            width: 12,
            height: 12,
            color: _categoryColors[index],
          ),
          title: Text(
            category['name'],
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            'Priority: ${category['priority'].toUpperCase()} | ${category['percentage'].toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'low':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      case 'high':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _fetchDynamicData() async {
    // Implement your data fetching logic here
  }

  void _updateBudgetCategories(List<Map<String, dynamic>> newCategories) {
    setState(() {
      budgetCategories.clear();
      budgetCategories.addAll(newCategories);
      _generateCategoryColors();
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: SpendingBudgetsView(),
  ));
}