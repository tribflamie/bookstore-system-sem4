import 'package:coffe_management/service/Odersservice.dart';
import 'package:coffe_management/ui/MyHomePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../service/user_provider.dart';
import '../LoginPage.dart';
import '../RegisterPage.dart';
import 'checkout_bottom_sheet.dart';

class CartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int> quantities = [];

  void initializeQuantities(List<Map<String, dynamic>> orderList) {
    quantities.clear();
    for (var order in orderList) {
      quantities.add(order['quantity']);
    }
  }

  void incrementQuantity(int index) {
    setState(() {
      if (quantities[index] < orderList[index]['productid']['quantity']) {
        quantities[index]++;
      }
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (quantities[index] > 1) {
        quantities[index]--;
      }
    });
  }

  List<Map<String, dynamic>> orderList = [];

  @override
  void initState() {
    super.initState();
    orderList;
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      // Gọi hàm lấy dữ liệu khách hàng từ API
      List<Map<String, dynamic>> orders = await Odersservice().getOrders();

      setState(() {
        orderList = orders;
        initializeQuantities(orderList);
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error loading orders: $e');
      // Hiển thị thông báo lỗi cho người dùng nếu cần thiết
      // showDialog(context: context, builder: (context) => AlertDialog(title: Text('Error'), content: Text('Failed to load customers. $e')));
    }
  }

  double calculateTotalSubtotalForUser(
      List<Map<String, dynamic>> orderList, String username) {
    double totalSubtotal = 0.0;

    List<Map<String, dynamic>> filteredOrders = orderList
        .where((order) =>
    order['userId']['username'] == username && order['status'] == false)
        .toList();

    for (var order in filteredOrders) {
      totalSubtotal += order['subtotal'];
    }

    return totalSubtotal;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFfbf6f7),
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
        padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
        children: [
          Title(
            color: Color(0xFF2f567a),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'MY CART',
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFf0f8ff),
            ),
            child: Text(
              'Product',
              style: TextStyle(
                color: Color(0xFF2f567a),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          userProvider.isLoggedIn
              ? Container(
            child: Column(
              children: orderList
                  .where((order) =>
              order['userId']['username'] ==
                  userProvider.username &&
                  order['status'] != true)
                  .map((order) {
                int index = orderList.indexOf(order);
                var _id = order['id'];
                var _sellingprice = order['sellingprice'];
                var _productid = order['productid']['id'];
                var _status = false;
                var _userid = order['userId']['id'];
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image(
                          image: AssetImage(
                              'assets/images/${order['productid']['image']}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['productid']['productname'].toString(),
                            style: TextStyle(
                                color: Color(0xFF325976),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Price: \$' +
                                    order['sellingprice'].toString(),
                                style: TextStyle(
                                    color: Color(0xFF325976),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 20),
                              Text(
                                'Subtotal: \$' +
                                    order['subtotal'].toString(),
                                style: TextStyle(
                                    color: Color(0xFF325976),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.solidSquareMinus,
                                  color: Color(0xFF325976),
                                ),
                                onPressed: () => decrementQuantity(index),
                              ),
                              Text(
                                '${quantities[index]}',
                                style: TextStyle(
                                  color: Color(0xFF325976),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.solidSquarePlus,
                                  color: Color(0xFF325976),
                                ),
                                onPressed: () => incrementQuantity(index),
                              ),
                              SizedBox(width: 35),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await Odersservice().EditOrder(
                                      _id,
                                      quantities[index],
                                      _sellingprice,
                                      _status,
                                      _productid,
                                      _userid,
                                    );

                                    await loadOrders();
                                  } catch (e) {
                                    print('Failed to edit order: $e');
                                  }
                                },
                                child: Icon(
                                  FontAwesomeIcons.edit,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    int id = order['id'];
                                    await Odersservice()
                                        .deleteByIdOrder(id);
                                    setState(() {
                                      orderList.removeWhere(
                                              (order) => order['id'] == id);
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        content: Text(
                                            'The order has been successfully deleted'),
                                        backgroundColor: Colors.red));
                                  } catch (e) {
                                    // Xử lý lỗi nếu có
                                    print('Failed to delete order: $e');
                                  }
                                },
                                child: Icon(
                                  FontAwesomeIcons.solidTrashCan,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          )
              : Container(),
          Divider(
            thickness: 1,
            color: Color(0xFF2f567a),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'SUBTOTAL',
                style: TextStyle(
                    color: Color(0xFF2f567a),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "\$${calculateTotalSubtotalForUser(orderList, userProvider.username)}",
                      style: TextStyle(
                          color: Color(0xFF2f567a),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          ),
          SizedBox(height: 20),
          getCheckoutButton(context)
        ],
      ),
    );
  }

  Widget getCheckoutButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFf0f8ff),
      ),
      child: TextButton(
        child: Text(
          'Proceed To Checkout',
          style: TextStyle(
            color: Color(0xFF2f567a),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          showBottomSheet(context);
        },
      ),
    );
  }

  // Widget getButtonPriceWidget() {
  //   return Container(
  //     padding: EdgeInsets.all(2),
  //     decoration: BoxDecoration(
  //       color: Color(0xff489E67),
  //       borderRadius: BorderRadius.circular(4),
  //     ),
  //     child: Text(
  //       "\$12.96",
  //       style: TextStyle(fontWeight: FontWeight.w600),
  //     ),
  //   );
  // }

  void showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return CheckoutBottomSheet();
        });
  }
}
