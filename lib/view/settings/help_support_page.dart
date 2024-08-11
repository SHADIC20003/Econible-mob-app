import 'package:flutter/material.dart';
import '../../common/color_extension.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      appBar: AppBar(
        backgroundColor: TColor.gray,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Help and Support", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Help and Support",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "For any assistance or queries, please contact us at:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Email: support@econible.com",
              style: TextStyle(
                color: Color(0XFF4d4d4d),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Phone: +1 234 567 890",
              style: TextStyle(
                color: Color(0XFF4d4d4d),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Our support team is available 24/7 to help you with any issues or questions you may have.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
