import 'dart:convert';


import 'package:BookstoreApp/Utils/SD_CLIENT.dart';
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";

class Odersservice {
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await http.get(Uri.parse(SD_CLIENT.api_order));

      print('API Response order: ${response.body}'); // In ra nội dung phản hồi

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData != null) {
          // Assuming your API response contains a list of customers
          List<Map<String, dynamic>> orderList =
          (jsonData as List).cast<Map<String, dynamic>>().toList();

          return orderList;
        } else {
          // Handle the case when 'customer' key is not present in the response
          throw Exception(
              'API response does not contain the expected "order" key.');
        }
      } else {
        // Handle the case when the server returns an error status code
        throw Exception(
            'Failed to load orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the HTTP request
      print('Error fetching orders: $e');
      throw Exception('Failed to load orders. Error: $e');
    }
  }

  String getCurrentDateTime() {
    // Lấy ngày giờ hiện tại
    DateTime now = DateTime.now();

    // Định dạng chuỗi theo định dạng mong muốn (ví dụ: 'yyyy-MM-dd HH:mm:ss')
    String formattedDate =
    DateFormat('EEE MMM dd HH:mm:ss \'ICT\' yyyy').format(DateTime.now());

    return formattedDate;
  }

  Future<void> createOrder(int quantity, double sellingprice,
      bool status, int productid, int userid) async {
    String startdate = getCurrentDateTime();
    double subtotal = quantity * sellingprice;

    final response = await http.post(
      Uri.parse(SD_CLIENT.api_createorder),
      headers: <String, String>{
        'content-type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': DateTime.now().microsecond,
        'quantity': quantity,
        'subtotal': subtotal,
        'sellingprice': sellingprice,
        'status': status,
        'startdate': startdate,
        'productid': {'id': productid},
        'userId': {'id': userid},
      }),
    );

    if (response.statusCode == 201) {
      print('Order create successfully');
    } else {
      throw Exception(
          'Create order failed with status: ${response.statusCode}');
    }
  }

  Future<void> EditOrder(int id ,int quantity, double sellingprice,
      bool status, int productid, int userid) async {
    String startdate = getCurrentDateTime();
    double subtotal = quantity * sellingprice;
    final response = await http.post(
      Uri.parse(SD_CLIENT.api_createorder),
      headers: <String, String>{
        'content-type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'quantity': quantity,
        'subtotal': subtotal,
        'sellingprice': sellingprice,
        'status': status,
        'startdate': startdate,
        'productid': {'id': productid},
        'userId': {'id': userid},
      }),
    );
    if (response.statusCode == 201) {
      print('Order edit successfully');
    } else {
      throw Exception(
          'Create order failed with status: ${response.statusCode}');
    }
  }


  Future<void> deleteByIdOrder(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${SD_CLIENT.api_deleteorder}/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('API Response order: ${response.body}');

      if (response.statusCode == 204) {
        print('Order deleted successfully');
      } else {
        throw Exception(
            'Failed to delete order with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProductshistory() async {
    try {
      final response = await http.get(Uri.parse(SD_CLIENT.api_producthistory));

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData != null) {
          // Assuming your API response contains a list of customers
          List<Map<String, dynamic>> producthistoryList =
          (jsonData as List)
              .cast<Map<String, dynamic>>()
              .toList();


          return producthistoryList;
        } else {
          // Handle the case when 'customer' key is not present in the response
          throw Exception(
              'API response does not contain the expected "product history" key.');
        }
      } else {
        // Handle the case when the server returns an error status code
        throw Exception(
            'Failed to load products history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the HTTP request
      print('Error fetching products history: $e');
      throw Exception('Failed to load products history. Error: $e');
    }
  }

  Future<Map<String, dynamic>> getproductcartDetailsById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${SD_CLIENT.api_detailsorder}/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('API Response order details: ${response.body}');

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
