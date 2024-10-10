import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

final Logger logger = Logger();
Future<int> getRandomNumber() async {
  final url = Uri.parse(
      'https://api.allorigins.win/get?url=http://www.randomnumberapi.com/api/v1.0/random&cacheBust=${DateTime.now().millisecondsSinceEpoch}');
  final response = await http.get(url);

  logger.i('Response Status Code: ${response.statusCode}');
  logger.i('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    String contents = jsonData['contents'];
    List<dynamic> numbers = json.decode(contents);
    return numbers[0];
  } else {
    throw Exception('Failed to load random number');
  }
}
