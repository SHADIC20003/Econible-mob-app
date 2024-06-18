import 'package:flutter/material.dart';
import 'package:trackizer/view/more_options/charity.dart';
import 'package:trackizer/view/more_options/education.dart'; // Import the FinanceEducationPage
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/view/more_options/reminders.dart';
import 'package:trackizer/view/more_options/setgoals.dart';

class MoreOptionsPage extends StatelessWidget {
  const MoreOptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: TColor.gray70,
      appBar: AppBar(
        title: Text('More Options'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          _buildMoreOption(
            title: 'Charity Organizations',
            icon: Icons.favorite,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CharityOrganizationsPage()),
              );
            },
          ),
          _buildMoreOption(
            title: 'Educational Content Page',
            icon: Icons.school,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FinanceEducationPage()), // Navigate to the FinanceEducationPage
              );
            },
          ),
          _buildMoreOption(
            title: 'Set-up bill payment reminders',
            icon: Icons.payment,
            onTap: () {
Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemindersPage()), // Navigate to the FinanceEducationPage
              );            },
          ),
          _buildMoreOption(
            title: 'Set-up goals',
            icon: Icons.star,
            onTap: () {
Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SetGoalsPage()), 
              );            },
          ),
        ],
      ),
    );
  }

  Widget _buildMoreOption({required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }
}
