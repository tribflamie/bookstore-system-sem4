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
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              SizedBox(width: 6),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(20), // Điều chỉnh độ cong tùy ý ở đây
                child: Image(
                  image: AssetImage('assets/logoP2.jpg'),
                  height: 50,
                  width: 50,
                  fit: BoxFit
                      .cover, // Đảm bảo hình ảnh bị cắt ngang hoặc dọc nếu không phù hợp
                ),
              ),
              Text(
                'Book',
                style: TextStyle(
                    color: Color(0xFF3e6d99),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6),
              Text('Store',
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
                    color: Colors.white,
                    icon: Icon(
                      Icons.person,
                      color: Color(0xFF3e6d99),
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
                                    fontSize: 35,
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
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Visibility(
                        visible: selectedButton == 1,
                        child: Column(
                          children: [
                            Text(
                              'OUR INNOVATIONS AND MISSIONS',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2f567a)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'At Boostore, our mission is to empower customers by providing a seamless shopping experience that combines quality products, exceptional service, and innovative technology. We strive to inspire and support our community through a curated selection of items that enhance everyday life, all while fostering sustainability and social responsibility.',
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
                "WHY WE ARE DIFFERENT",
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
                              "Curated Selection",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "We carefully handpick our products to ensure quality and uniqueness, offering items that stand out in the marketplace.",
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
                              "Customer-Centric Approach",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "We prioritize our customers’ needs, providing personalized recommendations and exceptional support to create a memorable shopping experience.",
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
                              "Innovative Technology",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "Our platform utilizes cutting-edge technology to streamline the shopping process, making it easier and faster for customers to find exactly what they need.",
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
                              "Sustainability Commitment",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "We actively seek out eco-friendly products and practices, ensuring our operations contribute positively to the environment.",
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
                              "Community Engagement",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "We believe in giving back and actively support local initiatives, fostering a sense of community and social responsibility.",
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
                              "Transparent Practices",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    Text(
                      "We maintain transparency in our sourcing and pricing, building trust with our customers.",
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
                              'Our Categories',
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
                              'Help',
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
                              'New Authors',
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
                              'All Products',
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
                              'Privacy Policy',
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
                              'Terms of Service',
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
                              'Forums',
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
                              'Download',
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
                            'Address: 9786 Bernier Mountains Suite 328',
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
                            '+99 (999) 999 9999',
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
                            'Bookstore@gmail.com',
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
                          text:
                              '© 2024 Your Website Bookstore Management System ',
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
