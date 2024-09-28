import 'dart:convert';


import 'package:BookstoreApp/Utils/SD_CLIENT.dart';
import 'package:http/http.dart' as http;

class Categoryservice {
  Future<List<Map<String, dynamic>>> getCategory() async {
    try {
      final response = await http.get(Uri.parse(SD_CLIENT.api_category));

      print('API Response category: ${response.body}');  // In ra nội dung phản hồi

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData != null) {
          // Assuming your API response contains a list of customers
          List<Map<String, dynamic>> categoryList =
          (jsonData as List)
              .cast<Map<String, dynamic>>()
              .toList();


          return categoryList;
        } else {
          // Handle the case when 'customer' key is not present in the response
          throw Exception(
              'API response does not contain the expected "category" key.');
        }
      } else {
        // Handle the case when the server returns an error status code
        throw Exception(
            'Failed to load category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the HTTP request
      print('Error fetching category: $e');
      throw Exception('Failed to load products. Error: $e');
    }
  }
}