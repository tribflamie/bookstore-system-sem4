import 'package:coffe_management/service/Odersservice.dart';
import 'package:coffe_management/service/user_provider.dart';
import 'package:coffe_management/ui/LoginPage.dart';
import 'package:coffe_management/ui/RegisterPage.dart';
import 'package:coffe_management/ui/detail_product_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProducthistoryState();
}

class _ProducthistoryState extends State<ProductHistory> {
  List<Map<String, dynamic>> producthistoryList = [];
  @override
  void initState() {
    super.initState();
    loadProductshistory();
  }

  Future<void> loadProductshistory() async {
    try {
      // Gọi hàm lấy dữ liệu khách hàng từ API
      List<Map<String, dynamic>> productsHistory =
      await Odersservice().getProductshistory();

      setState(() {
        producthistoryList = productsHistory;
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error loading products history: $e');
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
          Title(
            color: Color(0xFF2f567a),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Purchase History Product',
                style: TextStyle(
                  color: Color(0xFF2f567a),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 30),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Username')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Items')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Details')), // Thêm cột mới cho Details
              ],
              rows: producthistoryList
                  .where((product) =>
              product['userId']['username'] == userProvider.username)
                  .map((product) {
                Color statusColor = Colors.black;

                if (product['status'] == 'Completed') {
                  statusColor = Colors.green;
                } else if (product['status'] == 'In progress') {
                  statusColor = Colors.red;
                }

                return DataRow(
                  cells: [
                    DataCell(Text(product['userId']?['username'] ?? '')),
                    DataCell(Text('\$${product['total'] ?? ''}')),
                    DataCell(Text(product['items']?.toString() ?? '')),
                    DataCell(
                      Text(
                        product['status'] ?? '',
                        style: TextStyle(color: statusColor),
                      ),
                    ),
                    DataCell(
                      // Thêm ô cho Details
                      IconButton(
                        icon: Icon(Icons.details),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsHistory(
                                orderDetails: product['id'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
