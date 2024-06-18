import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:trackizer/common/color_extension.dart';


class FinanceEducationPage extends StatelessWidget {
  const FinanceEducationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray50,
      appBar: AppBar(
        title: Text('Finance Education') , backgroundColor: TColor.gray80,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Personal Finance Basics'), 
            _buildResourceTile(
              title: 'Investopedia - Personal Finance Basics',
              description:
                  'A comprehensive guide covering various aspects of personal finance.',
              url: 'https://www.investopedia.com/personal-finance-4689758',
            ),
            _buildResourceTile(
              title: 'NerdWallet - Personal Finance 101',
              description:
                  'A beginner\'s guide to managing your money and building wealth.',
              url: 'https://www.nerdwallet.com/article/finance/personal-finance/what-is-personal-finance',
            ),
            SizedBox(height: 20.0),
            _buildSectionTitle('Investing'),
            _buildResourceTile(
              title: 'Investopedia - Investing Basics',
              description:
                  'Learn the fundamentals of investing and how to get started.',
              url: 'https://www.investopedia.com/investing-basics-4689654',
            ),
            _buildResourceTile(
              title: 'The Motley Fool - How to Invest',
              description:
                  'A beginner\'s guide to investing in stocks, funds, and more.',
              url: 'https://www.fool.com/investing/how-to-invest/',
            ),
            SizedBox(height: 20.0),
            _buildSectionTitle('Budgeting and Saving'),
            _buildResourceTile(
              title: 'Dave Ramsey - Budgeting Basics',
              description:
                  'Simple budgeting tips and strategies to take control of your finances.',
              url: 'https://www.daveramsey.com/blog/the-truth-about-budgeting',
            ),
            _buildResourceTile(
              title: 'YNAB - You Need A Budget',
              description:
                  'A popular budgeting app and methodology to help you save money.',
              url: 'https://www.youneedabudget.com/',
            ),
            SizedBox(height: 20.0),
            _buildSectionTitle('Additional Resources'),
            _buildResourceTile(
              title: 'Bogleheads - Investment Philosophy',
              description:
                  'A community-driven investing philosophy based on the ideas of John C. Bogle.',
              url: 'https://www.bogleheads.org/wiki/Main_Page',
            ),
            _buildResourceTile(
              title: 'Khan Academy - Finance and Capital Markets',
              description:
                  'Free courses on finance, investing, and economics.',
              url: 'https://www.khanacademy.org/economics-finance-domain/core-finance',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildResourceTile({
    required String title,
    required String description,
    required String url,
  }) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        onTap: () {
          _launchURL(url);
        },
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
