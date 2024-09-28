import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:BookstoreApp/service/Odersservice.dart';
import 'package:BookstoreApp/service/Productservice.dart';
import 'package:BookstoreApp/service/user_provider.dart';
import 'package:BookstoreApp/ui/AboutUsPage.dart';
import 'package:BookstoreApp/ui/LoginPage.dart';
import 'package:BookstoreApp/ui/RegisterPage.dart';
import 'package:BookstoreApp/ui/product_details/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'ContactUsPage.dart';
import 'ProductPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> productList = [];

  int selectedButton = 1;
  int colorChangeButton = 0;
  int colorChangeButton1 = 0;
  final bool _status = false;
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
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      // Gọi hàm lấy dữ liệu khách hàng từ API
      List<Map<String, dynamic>> products =
          await Productservice().getProducts();

      setState(() {
        productList = products;
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error loading products: $e');
      // Hiển thị thông báo lỗi cho người dùng nếu cần thiết
      // showDialog(context: context, builder: (context) => AlertDialog(title: Text('Error'), content: Text('Failed to load customers. $e')));
    }
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
        // padding: EdgeInsets.zero,
        children: [
          // Start Banner
          CarouselSlider(
            options: CarouselOptions(
              height: 500,
              autoPlay: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 700),
              viewportFraction: 1,
            ),
            items: [
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/ly1.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Overlay
                    child: Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(
                              0.2), // Màu overlay với độ trong suốt
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'SIGN UP',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFc9d14c)),
                            ),
                            const Text(
                              'FOR BOOSTORE APP',
                              style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const Text(
                              'Let us handle the logistics while you settle in with a cup of tea and immerse yourself in the stories that inspire you',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFd7d7d7)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF629bd0),
                                fixedSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      3), // Độ bo tròn góc của nút
                                ),
                              ),
                              child: Text(
                                'SHOP NOW',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/ly2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Overlay
                    child: Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(
                              0.5), // Màu overlay với độ trong suốt
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'CHECKOUT',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFc9d14c)),
                            ),
                            const Text(
                              'THE NEW TITLES',
                              style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const Text(
                              'With our commitment to quality and variety, we strive to create a welcoming space for all book lovers',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFd7d7d7)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF629bd0),
                                fixedSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      3), // Độ bo tròn góc của nút
                                ),
                              ),
                              child: Text(
                                'SHOP NOW',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bg.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Overlay
                    child: Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(
                              0.5), // Màu overlay với độ trong suốt
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'PLEASE',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFc9d14c)),
                            ),
                            const Text(
                              'KEEP READING',
                              style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const Text(
                              'Keep the pages turning at home. Dive into your favorite stories, explore new worlds, and let your imagination soar',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFd7d7d7)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF629bd0),
                                fixedSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      3), // Độ bo tròn góc của nút
                                ),
                              ),
                              child: Text(
                                'SHOP NOW',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // End Banner

          // Start Quality Tested by Time
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFFc9d14c),
            child: Stack(
              children: [
                Container(
                  height: 500,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/hinh21.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Overlay
                  child: Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.5), // Màu overlay với độ trong suốt
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'NEW ROOM IS OPENED IN OCTOBER',
                              style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFc9d14c)),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              'Exciting new room launched this October! Join us to explore the possibilities and enjoy exclusive offers available this month',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFc9d14c),
                                fixedSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              child: Text(
                                'SHOP NOW',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // End Quality Tested by Time

          // Start Welcome To Our Farm
          const SizedBox(height: 18),
          Title(
            color: const Color(0xFF2f567a),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'BEST SELLERS',
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 500,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 700),
              viewportFraction: 1,
            ),
            items: [
              SizedBox(
                width: 370,
                height: 520,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(18),
                      children: [
                        const Image(
                          image: AssetImage('assets/hinh14.png'),
                        ),
                        Title(
                          color: const Color(0xFF2f567a),
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Hillary Rodham Clinton',
                                  style: TextStyle(
                                    color: Color(0xFF2f567a),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        ),
                        const Text(
                          "Something Lost, Something Gained: Reflections on Life, Love, and Liberty.",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('READ MORE'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 370,
                height: 520,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(18),
                      children: [
                        const Image(
                          image: AssetImage('assets/service-2.jpg'),
                        ),
                        Title(
                          color: const Color(0xFF2f567a),
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Ina Garten",
                                  style: TextStyle(
                                    color: Color(0xFF2f567a),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        ),
                        const Text(
                          "Be Ready When the Luck Happens: A Memoir.",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('READ MORE'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 370,
                height: 520,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(18),
                      children: [
                        const Image(
                          image: AssetImage('assets/hinh16.png'),
                        ),
                        Title(
                          color: const Color(0xFF2f567a),
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Bill O'Reilly",
                                  style: TextStyle(
                                    color: Color(0xFF2f567a),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        ),
                        const Text(
                          "Confronting the Presidents: No Spin Assessments from Washington to Biden.",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('READ MORE'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // End Welcome To Our Farm

          // Start New Products
          Title(
            color: const Color(0xFF2f567a),
            child: const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'PRODUCTS',
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 370,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 700),
              viewportFraction: 0.5,
            ),
            items: productList
                .where((product) => product['status'] == 'New')
                .map((product) {
              var quantity = 1;
              var sellingprice = product['sale'];
              var subtotal = product['sale'];
              var productid = product['id'];
              var userid = userProvider.id;
              return Builder(
                builder: (BuildContext context) {
                  return ListView(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 170,
                            child: Image(
                              image: AssetImage(
                                  'assets/images/${product['image']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 15,
                            right: 15,
                            child: Container(
                              width: 70,
                              height: 30,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF629bd0),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text(
                                'New',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        product['productname'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF43567a),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${product['price']}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            TextSpan(
                              text: '\t\t\t\$${product['sale']}', // Có thể thay đổi nếu cần
                              style: const TextStyle(
                                color: Color(0xFF6c9dd0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF629bd0),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                        productDetails: product['id']),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF629bd0), // Màu nền của nút
                                shape: const CircleBorder(),
                                padding:
                                    const EdgeInsets.all(10), // Hình dạng hình tròn
                              ),
                              child: const Icon(
                                Icons.production_quantity_limits,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFc9d14c),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (userProvider.isLoggedIn) {
                                  Odersservice().createOrder(
                                      quantity,
                                      sellingprice,
                                      _status,
                                      productid,
                                      userid);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('add to cart successfully'),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFc9d14c), // Màu nền của nút
                                shape: const CircleBorder(),
                                padding:
                                    const EdgeInsets.all(10), // Hình dạng hình tròn
                              ),
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),

          // End New Products

          // Start Why Choose Us
          Title(
            color: const Color(0xFF2f567a),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'WHY CHOOSE US',
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFc9d14c),
                ),
                child: const Icon(
                  Icons.house_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Choose us for a curated selection of books that inspires and delights. Our knowledgeable staff offers personalized recommendations, and we host engaging events that foster a love for reading. Plus, enjoy a cozy atmosphere and a community of fellow book lovers.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          // Start Latest News
          const SizedBox(height: 18),
          Container(
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
                      'LATEST NEWS',
                      style: TextStyle(
                        color: Color(0xFF2f567a),
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: 470,
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/hinh4.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Overlay
                          child: Positioned.fill(
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Septemper 20, 2024',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    'Many are focusing on local author signings to attract customers',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // End Latest News

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
                      'FOR NEW SUBSCRIBER',
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
