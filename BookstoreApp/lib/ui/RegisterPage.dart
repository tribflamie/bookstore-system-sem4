

import 'package:BookstoreApp/service/Registerservice.dart';
import 'package:BookstoreApp/ui/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _country = TextEditingController();
  final _phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = ''; // Error message variable

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _country.dispose();
    _phone.dispose();
    super.dispose();
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
            const SizedBox(height: 20),
            _buildAppLogo(),
            const SizedBox(height: 10),
            _buildTextField(_username, 'Full Name'),
            const SizedBox(height: 10),
            _buildTextField(_email, 'Email'),
            const SizedBox(height: 10),
            _buildPasswordTextField(),
            const SizedBox(height: 10),
            _buildTextField(_country, 'Address'),
            const SizedBox(height: 10),
            _buildTextField(_phone, 'Phone'),
            const SizedBox(height: 30),
            _buildRegisterButton(),
            const SizedBox(height: 50),
            _buildSignInLink(),
            const SizedBox(height: 20),
            // Display error message if it's not empty
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Text(
      'Register',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAppLogo() {
    return Column(
      children: [
        const Image(
          image: AssetImage('assets/logoP2.jpg'),
          height: 60,
          width: 60,
        ),
        if (_errorMessage.isNotEmpty)
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: _obscureText,
      controller: _password,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: _buildPasswordVisibilityToggle(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
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
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Clear error message before attempting registration
          setState(() {
            _errorMessage = '';
          });
          // Attempt registration
          Registerservice()
              .register(
            _username.text,
            _email.text,
            _password.text,
            _country.text,
            _phone.text,
          )
              .then((result) {
            // Check registration result
            if (result['success']) {
              // Registration successful, navigate to login page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            } else {
              // Registration failed, set error message
              setState(() {
                _errorMessage = result['error'];
              });
            }
          }).catchError((error) {
            // Registration failed due to exception, set error message
            setState(() {
              _errorMessage = '$error';
            });
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        fixedSize: const Size(1000, 45),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(30),
            right: Radius.circular(30),
          ),
        ),
      ),
      child: Text(
        'REGISTER',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don’t have an account? ',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: const Text(
            ' Sign In',
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
