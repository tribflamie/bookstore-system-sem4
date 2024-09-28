import 'dart:convert';

import 'package:BookstoreApp/service/Odersservice.dart';
import 'package:BookstoreApp/service/Productservice.dart';
import 'package:BookstoreApp/service/Categoryservice.dart';
import 'package:BookstoreApp/service/user_provider.dart';
import 'package:BookstoreApp/ui/AboutUsPage.dart';
import 'package:BookstoreApp/ui/cart/cart_screen.dart';
import 'package:BookstoreApp/ui/product_details/product_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:BookstoreApp/Utils/SD_CLIENT.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'ContactUsPage.dart';
import 'LoginPage.dart';
import 'MyHomePage.dart';
import 'RegisterPage.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  List<Map<String, dynamic>> productList = [];
  List<Map<String, dynamic>> categoryList = [];
  List<Map<String, dynamic>> productListPrice = [];
  String selectedCategory = 'All';
  TextEditingController searchController = TextEditingController();
  String selectedCategoryId = '';
  // order
  final bool _status = false;

  int colorChangeButton1 = 0;

  void changeColor1(int buttonIndex) {
    setState(() {
      colorChangeButton1 = buttonIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadCategories();
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

  Future<void> loadCategories() async {
    try {
      // Gọi hàm lấy dữ liệu khách hàng từ API
      List<Map<String, dynamic>> categories =
      await Categoryservice().getCategory();

      setState(() {
        categoryList = categories;
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error loading category: $e');
      // Hiển thị thông báo lỗi cho người dùng nếu cần thiết
      // showDialog(context: context, builder: (context) => AlertDialog(title: Text('Error'), content: Text('Failed to load customers. $e')));
    }
  }

  Future<void> searchProductsByPrice(String min, String max) async {
    try {
      if (min.isNotEmpty && max.isNotEmpty) {
        final double parsedMinPrice = double.parse(min);
        final double parsedMaxPrice = double.parse(max);

        final params = {
          'min': parsedMinPrice.toString(),
          'max': parsedMaxPrice.toString(),
        };

        final uriPrice = Uri.parse(SD_CLIENT.api_product_serachprice)
            .replace(queryParameters: params);

        print('Request price URI: $uriPrice');

        final response = await http.get(uriPrice);

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);

          if (jsonData != null) {
            productListPrice = (jsonData as List)
                .map((dynamic item) => item as Map<String, dynamic>)
                .toList();
          } else {
            throw Exception('API không chứa key "product" như mong đợi.');
          }
        } else {
          print('Lỗi: ${response.statusCode} - ${response.reasonPhrase}');
          // Xử lý các tình huống lỗi khác nếu cần
        }
      } else {
        // Lấy tất cả sản phẩm khi min và max không được cung cấp
        final response = await http.get(Uri.parse(SD_CLIENT.api_product));
        print('Phản hồi API: ${response.body}');

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);

          if (jsonData != null) {
            productListPrice = (jsonData as List)
                .map((dynamic item) => item as Map<String, dynamic>)
                .toList();
          } else {
            throw Exception('API không chứa key "product" như mong đợi.');
          }
        } else {
          throw Exception(
              'Không thể tải sản phẩm. Mã trạng thái: ${response.statusCode}');
        }
      }

      setState(() {
        productList = productListPrice;
      });
    } catch (e) {
      setState(() {
        productList = [];
      });
      print('Lỗi khi phân tích giá hoặc tải sản phẩm: $e');
    }
  }

  List<Map<String, dynamic>> getModifiedCategoryList() {
    List<Map<String, dynamic>> modifiedList = List.from(categoryList);

    // Check if "All" is already in the list
    bool hasAll =
    modifiedList.any((category) => category['categoryname'] == 'All');

    // Generate unique categoryid for other items in the list
    int uniqueId = 1;
    for (var category in modifiedList) {
      if (category['categoryname'] != 'All') {
        category['categoryid'] = uniqueId++;
      }
    }

    // Insert "All" with categoryid 0 if it's not already in the list
    if (!hasAll) {
      modifiedList.insert(0, {'categoryname': 'All', 'categoryid': 0});
    }

    return modifiedList;
  }

  Future<void> searchProductsBycategory(String categoryid) async {
    try {
      if (categoryid.isNotEmpty) {
        int parsedcategoryid = int.tryParse(categoryid) ?? 0;

        if (parsedcategoryid != 0) {
          final params = {
            'categoryid': parsedcategoryid.toString(),
          };

          final uricategory = Uri.parse(SD_CLIENT.api_product_bycategory)
              .replace(queryParameters: params);

          print('Request category URI: $uricategory');

          final response = await http.get(uricategory);

          if (response.statusCode == 200) {
            final jsonData = jsonDecode(response.body);

            if (jsonData != null) {
              List<Map<String, dynamic>> newCategoryList = (jsonData as List)
                  .map((dynamic item) => item as Map<String, dynamic>)
                  .toList();

              setState(() {
                productList = newCategoryList;
              });
            } else {
              throw Exception(
                  'API không chứa key "product category" như mong đợi.');
            }
          } else {
            print('Lỗi: ${response.statusCode} - ${response.reasonPhrase}');
            // Xử lý các tình huống lỗi khác nếu cần
          }
        } else {
          // Trường hợp categoryid là 0, hiển thị tất cả sản phẩm
          loadProducts();
        }
      }
    } catch (e) {
      setState(() {
        productList = [];
      });
      print('Lỗi khi phân tích giá hoặc tải sản phẩm: $e');
    }
  }

  DropdownButton<int> buildCategoryDropdownButton() {
    List<Map<String, dynamic>> modifiedCategoryList = getModifiedCategoryList();

    return DropdownButton<int>(
      value: int.tryParse(selectedCategoryId) ?? 0,
      onChanged: (int? newValue) {
        setState(() {
          selectedCategoryId = newValue!.toString();
          searchProductsBycategory(selectedCategoryId);
        });
      },
      items: modifiedCategoryList
          .map<DropdownMenuItem<int>>((Map<String, dynamic> value) {
        int categoryId = int.tryParse(value['id'].toString()) ?? 0;
        return DropdownMenuItem<int>(
          value: categoryId,
          child: Text(value['categoryname']),
        );
      }).toList(),
      dropdownColor: const Color(0xFF428bca),
      style: const TextStyle(color: Colors.white),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
    );
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
          Title(
            color: const Color(0xFF2f567a),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Product',
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
                margin: const EdgeInsets.only(left: 18, top: 10, right: 18),
                width: 400,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF428bca),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Sort By Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    buildCategoryDropdownButton(), // Hàm riêng cho DropdownButton
                  ],
                ),
              ),
              // Thêm các widget khác nếu cần
            ],
          ),
          // End Sort By Categories

          // Start Filter By
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 18, top: 10, right: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFe3f0fb),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF428bca),
                  ),
                  child: const Text(
                    'Filter By',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Price',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2f567a)),
                ),
                Container(
                  width: 310,
                  height: 80,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minPriceController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFcccccc)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFcccccc)),
                            ),
                            hintText: 'From',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 11, horizontal: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _maxPriceController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFcccccc)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFcccccc)),
                            ),
                            hintText: 'To',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 11, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    searchProductsByPrice(
                      _minPriceController.text,
                      _maxPriceController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF428bca),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    'Filter',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Divider(
                    color: Color(0xFFe3f0fb),
                    height: 0,
                    thickness: 0,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // End Filter By

          // Start Product
          const SizedBox(height: 30),

          Container(
            child: Wrap(
              runSpacing: 20,
              alignment: WrapAlignment.start,
              children: productList.map((product) {
                var quantity = 1;
                var sellingprice = product['sale'];
                var productid = product['id'];
                var userid = userProvider.id;
                return SizedBox(
                  width: 195,
                  height: 300,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 170,
                            height: 140,
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
                              width: 50,
                              height: 30,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF629bd0),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                product['status'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 170,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Color(0xFFf2f9ff),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              product['productname'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF43567a)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: '\$${product['price']}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                    '\t\t\t\$${product['sale']}',
                                    style: const TextStyle(
                                      color: Color(0xFF6c9dd0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF629bd0),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsScreen(
                                                  productDetails:
                                                  product['id']),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                            0xFF629bd0), // Màu nền của nút
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(
                                            7) // Hình dạng hình tròn
                                    ),
                                    child: const Icon(
                                      Icons.production_quantity_limits,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 40,
                                  height: 40,
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                                'add to cart successfully'),
                                            backgroundColor: Colors.blue));
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                            0xFFc9d14c), // Màu nền của nút
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(
                                            10) // Hình dạng hình tròn
                                    ),
                                    child: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          // )
          // End Product

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
                          text: '© 2024 Your Website Bookstore Management System ',
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
