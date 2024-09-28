import 'package:BookstoreApp/service/Odersservice.dart';
import 'package:BookstoreApp/service/Payservice.dart';
import 'package:BookstoreApp/ui/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/user_provider.dart';

class CheckoutBottomSheet extends StatefulWidget {
  const CheckoutBottomSheet({super.key});

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  final int _selectedValue = 1;
  int itemcount = 0;
  String payments = '';
  List<Map<String, dynamic>> orderList = [];

  @override
  void initState() {
    super.initState();
    orderList;
    loadOrders();
    itemcount;
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

  double calculateTotalSubtotalForUser(
      List<Map<String, dynamic>> orderList, String username) {
    double totalSubtotal = 0.0;
    int itemCount = 0; // Create a local variable to hold the item count

    List<Map<String, dynamic>> filteredOrders = orderList
        .where((order) =>
    order['userId']['username'] == username && order['status'] == false)
        .toList();

    // itemCount =  filteredOrders.length; // Update the local item count variable

    for (var order in filteredOrders) {
      totalSubtotal += order['subtotal'];
      itemCount++;
    }

    setState(() {
      itemcount = itemCount; // Update the item count using setState
    });

    return totalSubtotal;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    double total =
    calculateTotalSubtotalForUser(orderList, userProvider.username);
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Wrap(
        runSpacing: 10,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    "Checkout",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Full name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Container(
                width: 400,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(18)),
                child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return Text(userProvider.username,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal));
                    }),
              ),
              const SizedBox(height: 20),
              const Text(
                "Payment Method",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFfefdfe),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFf7f4f4),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Text(
                      'Cash On Delivery',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Radio(
                          value: 'Cash On Delivery',
                          groupValue: payments,
                          onChanged: (value) {
                            setState(() {
                              payments = value
                                  .toString(); // Cập nhật giá trị khi radio được chọn
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Product",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 13),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: orderList
                    .where((order) =>
                order['userId']['username'] == userProvider.username &&
                    order['status'] != true)
                    .map((order) {
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(
                      'assets/images/${order['productid']['image']}',
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),
              const Text(
                "Shopping Bill",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    "Items",
                    style: TextStyle(
                      color: Color(0xFFb4b4b4),
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$itemcount',
                        style: const TextStyle(
                          color: Color(0xFFb4b4b4),
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '\$${calculateTotalSubtotalForUser(orderList, userProvider.username)}',
                          style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (userProvider.isLoggedIn) {
                    Payservice().checkout(total, payments, itemcount,
                        userProvider.id, orderList, userProvider.username);
                    Navigator.pop(context); // Quay lại trang CartScreen
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Thank you for purchasing our products'),
                        backgroundColor: Colors.blue));
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  fixedSize: const Size(350, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  'Buy Now',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
