import 'dart:convert';


import 'package:coffe_management/Utils/SD_CLIENT.dart';
import 'package:http/http.dart' as http;

class Commentservice {
  Future<List<Map<String, dynamic>>> getComments() async {
    try {
      final response = await http.get(Uri.parse(SD_CLIENT.api_comment));

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData != null) {
          // Assuming your API response contains a list of customers
          List<Map<String, dynamic>> commentList =
          (jsonData as List).cast<Map<String, dynamic>>().toList();

          return commentList;
        } else {
          // Handle the case when 'customer' key is not present in the response
          throw Exception(
              'API response does not contain the expected "comment" key.');
        }
      } else {
        // Handle the case when the server returns an error status code
        throw Exception(
            'Failed to load comments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the HTTP request
      print('Error fetching comments: $e');
      throw Exception('Failed to load comments. Error: $e');
    }
  }

  Future<Map<String, dynamic>> createcomment(
      String comment, int rating, int productid, int userid) async {
    final response = await http.post(
      Uri.parse(SD_CLIENT.api_createcomment),
      headers: <String, String>{
        'content-type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'comment': comment,
        'rating': rating,
        'productid': {'id': productid},
        'userId': {'id': userid},
      }),
    );

    if (response.statusCode == 201) {
      // If the request was successful, return the customer data as a Map
      return jsonDecode(response.body);
    } else {
      // If the request was not successful, throw an exception
      throw Exception(
          'Add comment failed with status: ${response.statusCode}');
    }
  }
}
