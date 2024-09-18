import 'dart:convert';

import 'package:coffe_management/service/user_provider.dart';
import 'package:coffe_management/Utils/SD_CLIENT.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

class Payservice {
  String getCurrentDateTime() {
    // Lấy ngày giờ hiện tại
    DateTime now = DateTime.now();

    // Định dạng chuỗi theo định dạng mong muốn (ví dụ: 'yyyy-MM-dd HH:mm:ss')
    String formattedDate =
    DateFormat('EEE MMM dd HH:mm:ss \'ICT\' yyyy').format(DateTime.now());

    return formattedDate;
  }

  Future<void> checkout(double total, String payments,
      int items, int userid, List<Map<String, dynamic>> orderList , String username) async {

    String startdate = getCurrentDateTime();

    List<Map<String, dynamic>> filteredOrders = orderList
        .where((order) =>
    order['userId']['username'] == username && order['status'] == false)
        .toList();

    for (var order in filteredOrders) {
      String startdate = getCurrentDateTime();

      final responsecart = await http.post(
        Uri.parse('${SD_CLIENT.api_createorder}'),
        headers: <String, String>{
          'content-type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': order['id'],
          'quantity': order['quantity'],
          'subtotal': order['subtotal'],
          'sellingprice': order['sellingprice'],
          'status': true,
          'startdate': startdate,
          'productid': {'id': order['productid']['id']},
          'userId': {'id': order['userId']['id']},
        }),
      );

      print('Response: ${responsecart.body}');

      if (responsecart.statusCode == 201) {
        // if (responsecart.body.isNotEmpty) {
        print('Order create successfully');
        // } else {
        //   throw Exception('Response body is empty');
        // }
      } else {
        throw Exception(
            'Create order failed with status: ${responsecart.statusCode}');
      }
    }

    final response = await http.post(
      Uri.parse('${SD_CLIENT.api_checkoutorder}'),
      headers: <String, String>{
        'content-type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': DateTime.now().microsecond,
        'total': total,
        'updatedate': startdate,
        'payments': payments,
        'items': items,
        'status': 'In progress',
        'userId': {'id': userid},
      }),
    );
    if (response.statusCode == 201) {
      print('check out successfully');

    } else {
      throw Exception('check out failed with status: ${response.statusCode}');
    }
  }

}
