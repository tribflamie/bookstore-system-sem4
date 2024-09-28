// import 'package:flutter/cupertino.dart';
import 'package:BookstoreApp/service/user_provider.dart';
import 'package:BookstoreApp/ui/MyHomePage.dart';
import 'package:BookstoreApp/ui/ProductPage.dart';
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
              const SizedBox(width: 6),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(20), // Điều chỉnh độ cong tùy ý ở đây
                child: const Image(
                  image: AssetImage('assets/logoP2.jpg'),
                  height: 50,
                  width: 50,
                  fit: BoxFit
                      .cover, // Đảm bảo hình ảnh bị cắt ngang hoặc dọc nếu không phù hợp
                ),
              ),
              const Text(
                'Book',
                style: TextStyle(
                    color: Color(0xFF3e6d99),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6),
              const Text('Store',
                  style: TextStyle(
                      color: Color(0xFFbdc53b),
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 80),
              const Icon(
                Icons.search,
                size: 25,
                color: Color(0xFF3e6d99),
              ),
              const SizedBox(width: 20),
              Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFbdc53b),
                  ),
                  child: PopupMenuButton(
                    color: Colors.white,
                    icon: const Icon(
                      Icons.person,
                      color: Color(0xFF3e6d99),
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: GestureDetector(
                          child: Column(
                            children: [
                              const Text(
                                'Welcome',
                                style: TextStyle(
                                    color: Color(0xFF3e6d99),
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Consumer<UserProvider>(
                                  builder: (context, userProvider, child) {
                                return Text(userProvider.username,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal));
                              }),
                              Consumer<UserProvider>(
                                  builder: (context, userProvider, child) {
                                return Text(userProvider.email,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal));
                              }),
                              const SizedBox(height: 15),
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
                                          color: const Color(0xFF848b21),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: const Text(
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
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF848b21),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                          child: Text(
                                            'LOGIN',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
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
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF848b21),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                          child: Text(
                                            'REGISTER',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
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
            color: const Color(0xFF2f567a),
            child: const Padding(
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
              const Padding(
                padding: EdgeInsets.all(18),
                child: Image(image: AssetImage('assets/about.jpg')),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Visibility(
                        visible: selectedButton == 1,
                        child: const Column(
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
                        child: const Column(
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
                        child: const Column(
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
              const SizedBox(height: 20),
            ],
          ),
          // End About Us

          // Start Why We're Different
          Title(
            color: const Color(0xFF2f567a),
            child: const Padding(
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
                    color: const Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      FontAwesomeIcons.tree,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: const Color(0xFF2f567a),
                      child: const Padding(
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
                    const Text(
                      "We carefully handpick our products to ensure quality and uniqueness, offering items that stand out in the marketplace.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      FontAwesomeIcons.handScissors,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: const Color(0xFF2f567a),
                      child: const Padding(
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
                    const Text(
                      "We prioritize our customers’ needs, providing personalized recommendations and exceptional support to create a memorable shopping experience.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      FontAwesomeIcons.leaf,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: const Color(0xFF2f567a),
                      child: const Padding(
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
                    const Text(
                      "Our platform utilizes cutting-edge technology to streamline the shopping process, making it easier and faster for customers to find exactly what they need.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      FontAwesomeIcons.recycle,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: const Color(0xFF2f567a),
                      child: const Padding(
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
                    const Text(
                      "We actively seek out eco-friendly products and practices, ensuring our operations contribute positively to the environment.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      FontAwesomeIcons.wandMagicSparkles,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: const Color(0xFF2f567a),
                      child: const Padding(
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
                    const Text(
                      "We believe in giving back and actively support local initiatives, fostering a sense of community and social responsibility.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 350,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFe1f0ff),
                    width: 1,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      FontAwesomeIcons.lifeRing,
                      color: Color(0xFF629bd0),
                      size: 70,
                    ),
                    Title(
                      color: const Color(0xFF2f567a),
                      child: const Padding(
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
                    const Text(
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
            color: const Color(0xFF2f567a),
            child: const Padding(
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
                    color: const Color(0xFFe1f0ff),
                    width: 15,
                  ),
                ),
                child: const ClipOval(
                  child: Image(
                    image: AssetImage('assets/222.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
              const SizedBox(height: 18),
              const Text(
                'Lorem Magnis',
                style: TextStyle(
                    color: Color(0xFF325976),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 1
                          ? const Color(0xFFf56505)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.rss,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(2);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 2
                          ? const Color(0xFF3b5998)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(3);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 3
                          ? const Color(0xFF33ccff)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(4);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 4
                          ? const Color(0xFFbd3518)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.googlePlusG,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(5);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 5
                          ? const Color(0xFF007bb7)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.linkedinIn,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Column(
            children: [
              SizedBox(
                  child: Container(
                width: 370,
                height: 370,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFe1f0ff),
                    width: 15,
                  ),
                ),
                child: const ClipOval(
                  child: Image(
                    image: AssetImage('assets/223.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
              const SizedBox(height: 18),
              const Text(
                'Eget Nulla',
                style: TextStyle(
                    color: Color(0xFF325976),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 6
                          ? const Color(0xFFf56505)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.rss,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(7);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 7
                          ? const Color(0xFF3b5998)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(8);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 8
                          ? const Color(0xFF33ccff)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(9);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 9
                          ? const Color(0xFFbd3518)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.googlePlusG,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(10);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 10
                          ? const Color(0xFF007bb7)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.linkedinIn,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Column(
            children: [
              SizedBox(
                  child: Container(
                width: 370,
                height: 370,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFe1f0ff),
                    width: 15,
                  ),
                ),
                child: const ClipOval(
                  child: Image(
                    image: AssetImage('assets/224.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
              const SizedBox(height: 18),
              const Text(
                'Dapibus Diam',
                style: TextStyle(
                    color: Color(0xFF325976),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 11
                          ? const Color(0xFFf56505)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.rss,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(12);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 12
                          ? const Color(0xFF3b5998)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(13);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 13
                          ? const Color(0xFF33ccff)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(14);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 14
                          ? const Color(0xFFbd3518)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.googlePlusG,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeColor1(15);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorChangeButton1 == 15
                          ? const Color(0xFF007bb7)
                          : const Color(0xFFc9d14c),
                      fixedSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.linkedinIn,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // End Our Team

          // Start News Letter
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Title(
                  color: const Color(0xFF2f567a),
                  child: const Padding(
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
                        text: const TextSpan(children: [
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
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF629bd0),
                          fixedSize: const Size(150, 54),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(0),
                              right: Radius.circular(30),
                            ),
                          ),
                        ),
                        child: Text(
                          'SUBSCRIBE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
            color: const Color(0xFFfeffe7),
            child: Column(
              children: [
                Title(
                  color: const Color(0xFF2f567a),
                  child: const Padding(
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
                        child: const Image(
                      image: AssetImage('assets/hinh7.jpg'),
                      width: 100,
                      height: 70,
                      fit: BoxFit.cover,
                    )),
                    Container(
                        child: const Image(
                      image: AssetImage('assets/hinh8.jpg'),
                      width: 100,
                      height: 70,
                      fit: BoxFit.cover,
                    )),
                    Container(
                        child: const Image(
                      image: AssetImage('assets/hinh9.jpg'),
                      width: 100,
                      height: 70,
                      fit: BoxFit.cover,
                    )),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        child: const Image(
                      image: AssetImage('assets/hinh10.jpg'),
                      width: 100,
                      height: 70,
                      fit: BoxFit.cover,
                    )),
                    Container(
                        child: const Image(
                      image: AssetImage('assets/hinh11.jpg'),
                      width: 100,
                      height: 70,
                      fit: BoxFit.cover,
                    )),
                    Container(
                        child: const Image(
                      image: AssetImage('assets/hinh12.jpg'),
                      width: 100,
                      height: 70,
                      fit: BoxFit.cover,
                    )),
                  ],
                ),
                Title(
                  color: const Color(0xFF2f567a),
                  child: const Padding(
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
                const Row(
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
                  color: const Color(0xFF2f567a),
                  child: const Padding(
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
                    const Padding(
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
                    const Padding(
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
                    const Padding(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 16
                                ? const Color(0xFFf56505)
                                : const Color(0xFFc9d14c),
                            fixedSize: const Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Icon(
                            FontAwesomeIcons.rss,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 6),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              changeColor1(17);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 17
                                ? const Color(0xFF3b5998)
                                : const Color(0xFFc9d14c),
                            fixedSize: const Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 6),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              changeColor1(18);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 18
                                ? const Color(0xFF33ccff)
                                : const Color(0xFFc9d14c),
                            fixedSize: const Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 6),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              changeColor1(19);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 19
                                ? const Color(0xFFbd3518)
                                : const Color(0xFFc9d14c),
                            fixedSize: const Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Icon(
                            FontAwesomeIcons.googlePlusG,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 6),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              changeColor1(20);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorChangeButton1 == 20
                                ? const Color(0xFF007bb7)
                                : const Color(0xFFc9d14c),
                            fixedSize: const Size(45, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Icon(
                            FontAwesomeIcons.linkedinIn,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(
                  thickness: 1,
                  color: Color(0xFFfaffaa),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18, top: 10, bottom: 10, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: const TextSpan(children: [
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
