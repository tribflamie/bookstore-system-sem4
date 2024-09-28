import 'dart:convert';


import 'package:BookstoreApp/Utils/SD_CLIENT.dart';
import 'package:http/http.dart' as http;

class Productservice {
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(SD_CLIENT.api_product));

      print('API Response: ${response.body}');  // In ra nội dung phản hồi

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData != null) {
          // Assuming your API response contains a list of customers
          List<Map<String, dynamic>> productList =
          (jsonData as List)
              .cast<Map<String, dynamic>>()
              .toList();


          return productList;
        } else {
          // Handle the case when 'customer' key is not present in the response
          throw Exception(
              'API response does not contain the expected "product" key.');
        }
      } else {
        // Handle the case when the server returns an error status code
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the HTTP request
      print('Error fetching products: $e');
      throw Exception('Failed to load products. Error: $e');
    }
  }

  Future<Map<String, dynamic>> getOrderDetailsById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${SD_CLIENT.api_detailproduct}/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {

        Map<String, dynamic> orderDetails = jsonDecode(response.body);
        return orderDetails;
      } else {
        throw Exception(
          'Failed to fetch order details with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      throw Exception('Failed to fetch order details: $e');
    }
  }
}
