import 'dart:convert';


import 'package:BookstoreApp/Utils/SD_CLIENT.dart';
import 'package:http/http.dart' as http;

class Registerservice {
  Future<Map<String, dynamic>> register(String username, String email,
      String password, String country, String phone) async {
    final response = await http.post(
      Uri.parse(SD_CLIENT.api_registerurl),
      headers: <String, String>{
        'content-type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
        'country': country,
        'phone': phone
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'User registered successfully'};
    }else if(response.statusCode == 302){
      throw Exception('Email already exists');
    }
    else {
      // If the request was not successful, throw an exception
      throw Exception(
          'Add register failed');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(SD_CLIENT.api_loginurl),
        headers: <String, String>{
          'content-type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'An error occurred during login'};
    }
  }
}
