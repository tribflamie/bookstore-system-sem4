
// import 'package:flutter/cupertino.dart';
import 'package:coffe_management/service/user_provider.dart';
import 'package:coffe_management/ui/MyHomePage.dart';
import 'package:coffe_management/ui/ProductPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'ContactUsPage.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  int selectedButton = 1;
  int colorChangeButton = 0;
  int colorChangeButton1 = 0;

  void changeColor(int buttonIndex) {
    setState(() {
      colorChangeButton = buttonIndex;
    });
  }

  void changeColor1(int buttonIndex) {
    setState(() {
      colorChangeButton1 = buttonIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Padding(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Text(
                'Coffee',
                style: TextStyle(
                    color: Color(0xFF3e6d99),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(30), // Điều chỉnh độ cong tùy ý ở đây
                child: Image(
                  image: AssetImage('assets/logoP2.jpg'),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover, // Đảm bảo hình ảnh bị cắt ngang hoặc dọc nếu không phù hợp
                ),
              ),

              SizedBox(width: 6),
              Text('PAO',
                  style: TextStyle(
                      color: Color(0xFFbdc53b),
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 80),
              Icon(
                Icons.search,
                size: 25,
                color: Color(0xFF3e6d99),
              ),
              SizedBox(width: 20),
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFbdc53b),
                  ),
                  child: PopupMenuButton(
                    color: Colors.black87,
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Text(
                                'Welcome',
                                style: TextStyle(
                                    color: Color(0xFF3e6d99),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Consumer<UserProvider>(
                                  builder: (context, userProvider, child) {
                                    return Text(userProvider.username,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal));
                                  }),
                              Consumer<UserProvider>(
                                  builder: (context, userProvider, child) {
                                    return Text(userProvider.email,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal));
                                  }),
                              SizedBox(height: 15),
                              userProvider.isLoggedIn
                                  ? GestureDetector(
                                onTap: () {
                                  Provider.of<UserProvider>(context,
                                      listen: false)
                                      .logout();
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF848b21),
                                    borderRadius:
                                    BorderRadius.circular(3),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                                  : Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    },
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF848b21),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage()));
                                    },
                                    child: Text(
                                      'REGISTER',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF848b21),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          // Start About Us
          Title(
            color: Color(0xFF2f567a),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'About Us',
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(18),
                child: Image(image: AssetImage('assets/about.jpg')),
              ),
              Wrap(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedButton = 1;
                        changeColor(1);
                      });
                    },
                    child: Text(
                      'OUR MISSION',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: colorChangeButton == 1
                          ? Color(0xFF629bd0)
                          : Color(0xFFf2f9ff),
                      foregroundColor: colorChangeButton == 1
                          ? Colors.white
                          : Color(0xFF629bd0),
                      fixedSize: Size(140, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedButton = 2;
                        changeColor(2);
                      });
                    },
                    child: Text(
                      'QUALITY CONTROL',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: colorChangeButton == 2
                          ? Color(0xFF629bd0)
                          : Color(0xFFf2f9ff),
                      foregroundColor: colorChangeButton == 2
                          ? Colors.white
                          : Color(0xFF629bd0),
                      fixedSize: Size(190, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedButton = 3;
                        changeColor(3);
                      });
                    },
                    child: Text(
                      'OUR GOALS',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: colorChangeButton == 3
                          ? Color(0xFF629bd0)
                          : Color(0xFFf2f9ff),
                      foregroundColor: colorChangeButton == 3
                          ? Colors.white
                          : Color(0xFF629bd0),
                      fixedSize: Size(130, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Visibility(
                        visible: selectedButton == 1,
                        child: Column(
                          children: [
                            Text(
                              'INTEGRATING INNOVATIONS INTO COFFEE TRADITIONS',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2f567a)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Our mission is to create a sustainable, environmentally and technologically advanced coffee shop. We adhere to natural coffee traditions combined with innovation. Our mission is to create a sustainable, environmentally and technologically advanced coffee shop. We adhere to natural coffee traditions combined with innovation.',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )),
                    Visibility(
                        visible: selectedButton == 2,
                        child: Column(
                          children: [
                            Text(
                              'ENSURING THE HIGHEST QUALITY OF OUR PRODUCTS',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2f567a)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Our mission is to create a sustainable, environmentally and technologically advanced coffee shop. We adhere to natural coffee traditions combined with innovation. Our mission is to create a sustainable, environmentally and technologically advanced coffee shop. We adhere to natural coffee traditions combined with innovation.',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )),
                    Visibility(
                        visible: selectedButton == 3,
                        child: Column(
                          children: [
                            Text(
                              'OUR POSITION IS PRINCIPLED TO FEED YOU WITH TASTY PRODUCE',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2f567a)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Our mission is to create a sustainable, environmentally and technologically advanced coffee shop. We adhere to natural coffee traditions combined with innovation. Our mission is to create a sustainable, environmentally and technologically advanced coffee shop. We adhere to natural coffee traditions combined with innovation.',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()));
                },
                child: Text(
                  'READ MORE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFc9d14c),
                  fixedSize: Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          // End About Us

          // Start Why We're Different
          Title(
            color: Color(0xFF2f567a),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Why We're Different",
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(18),
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      FontAwesomeIcons.tree,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: Color(0xFF2f567a),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Litora Torquent Conubia",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(18),
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      FontAwesomeIcons.handScissors,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: Color(0xFF2f567a),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Litora Augue",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(18),
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      FontAwesomeIcons.leaf,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: Color(0xFF2f567a),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Litora Sagittis",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(18),
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      FontAwesomeIcons.recycle,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: Color(0xFF2f567a),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Litora Torquent Conubia",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(18),
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      FontAwesomeIcons.wandMagicSparkles,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: Color(0xFF2f567a),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Litora Augue",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(18),
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      FontAwesomeIcons.lifeRing,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: Color(0xFF2f567a),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Litora Sagittis",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // End Why We're Different

          // Start Popular Categories
          Title(
            color: Color(0xFF2f567a),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Popular Categories",
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                  width: 350,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFfdffc8),
                    border: Border.all(
                      color: Color(0xFFfdffc8),
                      width: 1,
                    ),
                  ),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(18),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'COFFEE MACHINE',
                                  style: TextStyle(
                                      color: Color(0xFF2f567a),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Morbi sed aliquet felis pellentesque daculis multricies metus.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/hinh13.jpg'),
                            width: 110,
                            height: 110,
                          )
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 15),
              Container(
                  width: 350,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFfdffc8),
                    border: Border.all(
                      color: Color(0xFFfdffc8),
                      width: 1,
                    ),
                  ),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(18),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DRINK COFFEE',
                                  style: TextStyle(
                                      color: Color(0xFF2f567a),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Morbi sed aliquet felis pellentesque daculis multricies metus.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/hinh14.png'),
                            width: 110,
                            height: 110,
                          )
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 15),
              Container(
                  width: 350,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFfdffc8),
                    border: Border.all(
                      color: Color(0xFFfdffc8),
                      width: 1,
                    ),
                  ),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(18),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FILTER BAG COFFEE',
                                  style: TextStyle(
                                      color: Color(0xFF2f567a),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Morbi sed aliquet felis pellentesque daculis multricies metus.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/hinh16.png'),
                            width: 110,
                            height: 110,
                          )
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 15),
              Container(
                  width: 350,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFfdffc8),
                    border: Border.all(
                      color: Color(0xFFfdffc8),
                      width: 1,
                    ),
                  ),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(18),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'POPULAR',
                                  style: TextStyle(
                                      color: Color(0xFF2f567a),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Morbi sed aliquet felis pellentesque daculis multricies metus.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/hinh17.jpg'),
                            width: 110,
                            height: 110,
                          )
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 15),
              Container(
                  width: 350,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFfdffc8),
                    border: Border.all(
                      color: Color(0xFFfdffc8),
                      width: 1,
                    ),
                  ),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(18),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NEW',
                                  style: TextStyle(
                                      color: Color(0xFF2f567a),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Morbi sed aliquet felis pellentesque daculis multricies metus.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/hinh18.jpg'),
                            width: 110,
                            height: 110,
                          )
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 15),
              Container(
                  width: 350,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFfdffc8),
                    border: Border.all(
                      color: Color(0xFFfdffc8),
                      width: 1,
                    ),
                  ),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(18),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BEST',
                                  style: TextStyle(
                                      color: Color(0xFF2f567a),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Morbi sed aliquet felis pellentesque daculis multricies metus.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/hinh19.jpg'),
                            width: 110,
                            height: 110,
                          )
                        ],
                      ),
                    ],
                  )),
            ],
          ),
          // End Popular Categories

          // Start Our Team
          Title(
            color: Color(0xFF2f567a),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'OUR TEAM',
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                  child: Container(
                    width: 370,
                    height: 370,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFe1f0ff),
                        width: 15,
                      ),
                    ),
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('assets/222.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              SizedBox(height: 18),
              Text(
                'Lorem Magnis',
                style: TextStyle(
                    color: Color(0xFF325976),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Richard has a wide experience in every dairy farming aspect as he’s been in the industry for over 20 years.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      changeColor1(1);
                    },
                    child: Icon(
                      FontAwesomeIcons.rss,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 1
                          ? Color(0xFFf56505)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(2);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 2
                          ? Color(0xFF3b5998)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(3);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 3
                          ? Color(0xFF33ccff)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(4);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.googlePlusG,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 4
                          ? Color(0xFFbd3518)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(5);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.linkedinIn,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 5
                          ? Color(0xFF007bb7)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 18),
          Column(
            children: [
              SizedBox(
                  child: Container(
                    width: 370,
                    height: 370,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFe1f0ff),
                        width: 15,
                      ),
                    ),
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('assets/223.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              SizedBox(height: 18),
              Text(
                'Eget Nulla',
                style: TextStyle(
                    color: Color(0xFF325976),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Richard has a wide experience in every dairy farming aspect as he’s been in the industry for over 20 years.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      changeColor1(6);
                    },
                    child: Icon(
                      FontAwesomeIcons.rss,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 6
                          ? Color(0xFFf56505)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(7);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 7
                          ? Color(0xFF3b5998)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(8);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 8
                          ? Color(0xFF33ccff)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(9);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.googlePlusG,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 9
                          ? Color(0xFFbd3518)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(10);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.linkedinIn,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 10
                          ? Color(0xFF007bb7)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 18),
          Column(
            children: [
              SizedBox(
                  child: Container(
                    width: 370,
                    height: 370,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFe1f0ff),
                        width: 15,
                      ),
                    ),
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('assets/224.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              SizedBox(height: 18),
              Text(
                'Dapibus Diam',
                style: TextStyle(
                    color: Color(0xFF325976),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Richard has a wide experience in every dairy farming aspect as he’s been in the industry for over 20 years.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      changeColor1(11);
                    },
                    child: Icon(
                      FontAwesomeIcons.rss,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 11
                          ? Color(0xFFf56505)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(12);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 12
                          ? Color(0xFF3b5998)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(13);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 13
                          ? Color(0xFF33ccff)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(14);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.googlePlusG,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 14
                          ? Color(0xFFbd3518)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(15);
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.linkedinIn,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 15
                          ? Color(0xFF007bb7)
                          : Color(0xFFc9d14c),
                      fixedSize: Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // End Our Team

          // Start News Letter
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Title(
                  color: Color(0xFF2f567a),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'NEWS LETTER',
                      style: TextStyle(
                        color: Color(0xFF2f567a),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Column(
                  children: [
                    RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Subscribe to our newsletter and get ',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          TextSpan(
                              text: '20%',
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xFF629bd0))),
                          TextSpan(
                              text: '  off your first purchase',
                              style: TextStyle(fontSize: 18, color: Colors.black))
                        ])),
                  ],
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFeeeeee)),
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(30),
                                right: Radius.circular(0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFeeeeee)),
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(30),
                                right: Radius.circular(0),
                              ),
                            ),
                            hintText: 'Your Email',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'SUBSCRIBE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF629bd0),
                          fixedSize: Size(150, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(0),
                              right: Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // End News Letter

          // Start Footer
          Container(
            color: Color(0xFFfeffe7),
            child: Column(
              children: [
                Title(
                  color: Color(0xFF2f567a),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'GALLERY',
                      style: TextStyle(
                        color: Color(0xFF2f567a),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        child: Image(
                          image: AssetImage('assets/hinh7.jpg'),
                          width: 100,
                          height: 70,
                          fit: BoxFit.cover,
                        )),
                    Container(
                        child: Image(
                          image: AssetImage('assets/hinh8.jpg'),
                          width: 100,
                          height: 70,
                          fit: BoxFit.cover,
                        )),
                    Container(
                        child: Image(
                          image: AssetImage('assets/hinh9.jpg'),
                          width: 100,
                          height: 70,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        child: Image(
                          image: AssetImage('assets/hinh10.jpg'),
                          width: 100,
                          height: 70,
                          fit: BoxFit.cover,
                        )),
                    Container(
                        child: Image(
                          image: AssetImage('assets/hinh11.jpg'),
                          width: 100,
                          height: 70,
                          fit: BoxFit.cover,
                        )),
                    Container(
                        child: Image(
                          image: AssetImage('assets/hinh12.jpg'),
                          width: 100,
                          height: 70,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
                Title(
                  color: Color(0xFF2f567a),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'QUICK LINKS',
                      style: TextStyle(
                        color: Color(0xFF2f567a),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'Our Blends',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'New Products',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'Top Sellers',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'About Us',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'MeNu',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'Contact Us',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'Coffee Beans ',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'Coffee Product',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'Preparation Tools',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'Drunk Coffee',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'Ice Cream',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.arrow_right, color: Color(0xFF629bd0)),
                            Text(
                              'Other',
                              style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Title(
                  color: Color(0xFF2f567a),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'GET IN TOUCH',
                      style: TextStyle(
                        color: Color(0xFF2f567a),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 18, bottom: 18),
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.solidMap,
                              color: Color(0xFF629bd0)),
                          SizedBox(width: 10),
                          Text(
                            ' Address :115 HoTungMau.Q1.TP.HCM',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18, bottom: 18),
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: Color(0xFF629bd0)),
                          SizedBox(width: 10),
                          Text(
                            '+84 (356) 456 7890',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18, bottom: 18),
                      child: Row(
                        children: [
                          Icon(Icons.email, color: Color(0xFF629bd0)),
                          SizedBox(width: 10),
                          Text(
                            'CoffeePAO@gmail.com',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            changeColor1(16);
                          },
                          child: Icon(
                            FontAwesomeIcons.rss,
                            color: Colors.white,
                            size: 20,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 16
                                ? Color(0xFFf56505)
                                : Color(0xFFc9d14c),
                            fixedSize: Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              changeColor1(17);
                            });
                          },
                          child: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.white,
                            size: 20,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 17
                                ? Color(0xFF3b5998)
                                : Color(0xFFc9d14c),
                            fixedSize: Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              changeColor1(18);
                            });
                          },
                          child: Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                            size: 20,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 18
                                ? Color(0xFF33ccff)
                                : Color(0xFFc9d14c),
                            fixedSize: Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              changeColor1(19);
                            });
                          },
                          child: Icon(
                            FontAwesomeIcons.googlePlusG,
                            color: Colors.white,
                            size: 20,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 19
                                ? Color(0xFFbd3518)
                                : Color(0xFFc9d14c),
                            fixedSize: Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              changeColor1(20);
                            });
                          },
                          child: Icon(
                            FontAwesomeIcons.linkedinIn,
                            color: Colors.white,
                            size: 20,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 20
                                ? Color(0xFF007bb7)
                                : Color(0xFFc9d14c),
                            fixedSize: Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Divider(
                  thickness: 1,
                  color: Color(0xFFfaffaa),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(left: 18, top: 10, bottom: 10, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: '© 2024 Your Website Coffee Management System ',
                              style: TextStyle(fontSize: 16.5, color: Colors.black),
                            ),
                            TextSpan(
                                text: 'TemplateOnWeb',
                                style: TextStyle(
                                    fontSize: 16.5,
                                    height: 1.5,
                                    color: Color(0xFF629bd0))),
                          ])),
                    ],
                  ),
                )
              ],
            ),
          ),
          // End Footer
        ],
      ),
    );
  }
}
