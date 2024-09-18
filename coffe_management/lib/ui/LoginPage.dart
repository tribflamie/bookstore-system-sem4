

import 'package:coffe_management/service/Registerservice.dart';
import 'package:coffe_management/service/user_provider.dart';
import 'package:coffe_management/ui/RegisterPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import 'NavigationBarPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() async {
    // Kiểm tra xem form có hợp lệ không
    if (_formKey.currentState!.validate()) {
      // Xóa thông báo lỗi trước khi thử đăng nhập lại
      setState(() {
        _errorMessage = '';
      });

      // Thực hiện đăng nhập
      final result = await Registerservice().login(
        _emailController.text,
        _passwordController.text,
      );

      // Kiểm tra kết quả đăng nhập
      if (result['success']) {
        // Đăng nhập thành công, chuyển hướng đến trang chính
        int id = result['data']['id'];
        String username = result['data']['username'];
        String email = result['data']['email'];
        context.read<UserProvider>().setUserInfo(id, username, email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationBarPage()),
        );
      } else {
        // Đăng nhập thất bại, hiển thị thông báo lỗi
        setState(() {
          _errorMessage = result['error'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $_errorMessage'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        width: 390,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView(
          children: [
            _buildWelcomeText(),
            SizedBox(height: 20),
            _buildAppLogo(),
            SizedBox(height: 10),
            _buildEmailField(),
            SizedBox(height: 10),
            _buildPasswordField(),
            SizedBox(height: 30),
            _buildRegisterButton(),
            SizedBox(height: 50),
            _buildSignInLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Text(
      'LoGin',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAppLogo() {
    return Image(

      image: AssetImage('assets/logoP2.jpg'),
      height: 60,
      width: 60,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 2),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        // Kiểm tra xem địa chỉ email có đúng định dạng hay không
        if (!EmailValidator.validate(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: _obscureText,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 2),
        suffixIcon: _buildPasswordVisibilityToggle(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return InkWell(
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
      child: Icon(
        _obscureText ? Icons.visibility : Icons.visibility_off,
        size: 20,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _login, // Gọi phương thức _login
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        fixedSize: Size(1000, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(30),
            right: Radius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don’t have an account? ',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterPage()));
          },
          child: Text(
            ' Sign Up',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }
}
