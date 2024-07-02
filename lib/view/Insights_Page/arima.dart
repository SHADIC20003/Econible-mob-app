import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<double>> getPredictions(double number) async {
  // Replace with the actual API URL
  final url = Uri.parse('https://pmdarima.onrender.com/');

  // Prepare the request body
  final data = {'data': [number]};
  final body = json.encode(data);

  // Send the POST request
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  // Check for successful response
  if (response.statusCode == 200) {
    final decodedResponse = json.decode(response.body);
    // Extract the predictions from the response
    final predictions = decodedResponse['predictions']?.cast<double>();
    if (predictions != null) {
      return predictions;
    } else {
      throw Exception('Error: No predictions found in response');
    }
  } else {
    throw Exception('Failed to get predictions: ${response.statusCode}');
  }
}