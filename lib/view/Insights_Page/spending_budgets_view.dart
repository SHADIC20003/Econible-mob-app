import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackizer/sqldb.dart';

class SpendingBudgetsView extends StatefulWidget {
  @override
  _SpendingBudgetsViewState createState() => _SpendingBudgetsViewState();
}

class _SpendingBudgetsViewState extends State<SpendingBudgetsView> {
  final Random _random = Random();
  bool _showPieChart = true;
  final List<Color> _categoryColors = [];
  bool _showLabels = true;
  List<Map<String, dynamic>> budgetCategories = [];
  final SqlDb sqldb = SqlDb();
  String? email = '';

  @override
  void initState() {
    super.initState();
    _fetchExpenseData();
  }

  Future<void> _fetchExpenseData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString('current_email');

    if (email != null && email!.isNotEmpty) {
      List<Map<String, dynamic>> data = await sqldb.readData("SELECT category, priority, SUM(amount) as totalAmount FROM Expense WHERE userEmail = '$email' GROUP BY category");
      double totalAmount = data.fold(0, (sum, item) => sum + (item['totalAmount'] ?? 0.0));

      setState(() {
        budgetCategories = data.map((item) => {
          "name": item['category'] ?? 'Unknown',
          "priority": item['priority'] ?? 'Low',
          "percentage": (item['totalAmount'] ?? 0) / totalAmount * 100,
        }).toList();
        _generateCategoryColors();
      });
    }
  }

  void _generateCategoryColors() {
    _categoryColors.clear();
    for (var i = 0; i < budgetCategories.length; i++) {
      _categoryColors.add(Color(_random.nextInt(0xFFFFFF)).withOpacity(1.0));
    }
  }

  void _toggleView() {
    setState(() {
      _showPieChart = !_showPieChart;
      _showLabels = !_showLabels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Insights Page'),
        backgroundColor: Colors.grey[850],
        actions: [
          IconButton(
            icon: Icon(_showPieChart ? Icons.list : Icons.pie_chart),
            onPressed: _toggleView,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _showPieChart ? _buildPieChartPage() : _buildCategoriesPage(),
      ),
    );
  }

  Widget _buildPieChartPage() {
    return Stack(
      children: [
        // Upper background layer
        Container(
          height: 300, // Adjust the height as needed
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey[800]!, Colors.grey[900]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
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
                        radius: 100,
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        badgeWidget: _buildBadge(category['name']),
                        badgePositionPercentageOffset: 0.95,
                      );
                    },
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(enabled: true),
                ),
              ),
            ),
            Divider(color: Colors.grey[700], thickness: 1), // Add a divider
            SizedBox(height: 16), // Add some space
            AnimatedOpacity(
              opacity: _showLabels ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _categoryColors[index],
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          category['name'],
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesPage() {
    return ListView.builder(
      itemCount: budgetCategories.length,
      itemBuilder: (context, index) {
        final category = budgetCategories[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == budgetCategories.length - 1 ? 100 : 12),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _categoryColors[index],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      category['name'],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Priority: ${category['priority']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
                SizedBox(height: 4),
                Text(
                  'Percentage: ${category['percentage'].toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SpendingBudgetsView(),
    theme: ThemeData.dark(),
  ));
}
