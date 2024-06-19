import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:trackizer/common/color_extension.dart';

class CharityOrganizationsPage extends StatelessWidget {
  const CharityOrganizationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Color.fromARGB(80, 80, 80, 75),
      appBar: AppBar(
        title: Text('Charity Organizations'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          _buildCharityLink(
            title: 'UNICEF',
            url: 'https://www.unicef.org/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'Red Cross',
            url: 'https://www.redcross.org/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'World Food Programme',
            url: 'https://www.wfp.org/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'Save the Children',
            url: 'https://www.savethechildren.org/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'Oxfam',
            url: 'https://www.oxfam.org/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'Doctors Without Borders',
            url: 'https://www.doctorswithoutborders.org/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'Charity: Water',
            url: 'https://www.charitywater.org/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'Action Against Hunger',
            url: 'https://www.actionagainsthunger.org/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'Red Crescent',
            url: 'https://www.ifrc.org/en/what-we-do/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'CARE',
            url: 'https://www.care.org/',
            icon: Icons.favorite,
          ),
          _buildCharityLink(
            title: 'Habitat for Humanity',
            url: 'https://www.habitat.org/',
            icon: Icons.favorite,
          ),
          // Add more charity links as needed
        ],
      ),
    );
  }

  Widget _buildCharityLink({required String title, required String url, required IconData icon}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white60, // Adjust the text color to white
      ),
    ),
    onTap: () {
      _launchURL(url); // Call _launchURL when the ListTile is tapped
    },
  );
}

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
