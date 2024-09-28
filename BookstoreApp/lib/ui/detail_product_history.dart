import 'package:BookstoreApp/service/Commentservice.dart';
import 'package:BookstoreApp/service/Odersservice.dart';
import 'package:BookstoreApp/service/Productservice.dart';
import 'package:BookstoreApp/ui/LoginPage.dart';
import 'package:BookstoreApp/ui/RegisterPage.dart';
import 'package:BookstoreApp/ui/product_details/rating_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../service/user_provider.dart';

class ProductDetailsHistory extends StatefulWidget {
  final dynamic orderDetails;
  const ProductDetailsHistory({super.key, this.orderDetails});

  @override
  State<StatefulWidget> createState() => _ProductDetailsHistoryState();
}

class _ProductDetailsHistoryState extends State<ProductDetailsHistory> {
  List<Map<String, dynamic>> orderList = [];
  Map<String, dynamic> orderDetailsData = {};

  @override
  void initState() {
    super.initState();
    orderList;
    loadOrders();
    getOrderDetails();
  }

  Future<void> loadOrders() async {
    try {
      // Gọi hàm lấy dữ liệu khách hàng từ API
      List<Map<String, dynamic>> orders = await Odersservice().getOrders();

      setState(() {
        orderList = orders;
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error loading orders: $e');
    }
  }

  Future<void> getOrderDetails() async {
    try {
      final details =
      await Odersservice().getproductcartDetailsById(widget.orderDetails);
      setState(() {
        orderDetailsData = details;
      });
    } catch (e) {
      print('Error fetching order details: $e');
    }
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
              const Text(
                'Coffee',
                style: TextStyle(
                    color: Color(0xFF3e6d99),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(30), // Điều chỉnh độ cong tùy ý ở đây
                child: const Image(
                  image: AssetImage('assets/logoP2.jpg'),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover, // Đảm bảo hình ảnh bị cắt ngang hoặc dọc nếu không phù hợp
                ),
              ),

              const SizedBox(width: 6),
              const Text('PAO',
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
                    color: Colors.black87,
                    icon: const Icon(
                      Icons.person,
                      color: Colors.black,
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
                                    fontSize: 28,
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
                'Details Purchase History Product',
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('product name')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Subtotal')),
                DataColumn(label: Text('Image')), // Thêm cột mới cho Image
              ],
              rows: orderList
                  .where((order) =>
              order['userId']['username'] == userProvider.username &&
                  order['status'] == true &&
                  order['startdate'] ==
                      orderDetailsData[
                      'updatedate']) // Fixed variable name here
                  .map((order) {
                return DataRow(
                  cells: [
                    DataCell(Text(order['productid']?['productname'] ?? '')),
                    DataCell(Text(order['quantity']?.toString() ?? '')),
                    DataCell(Text('\$${order['subtotal'] ?? ''}')),
                    DataCell(
                      // Display image
                      Image.asset(
                        'assets/images/${order['productid']['image']}',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
        ],
      ),
    );
  }
}
