import 'package:BookstoreApp/service/Commentservice.dart';
import 'package:BookstoreApp/service/Odersservice.dart';
import 'package:BookstoreApp/service/Productservice.dart';
import 'package:BookstoreApp/ui/product_details/rating_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../service/user_provider.dart';
import '../LoginPage.dart';
import '../RegisterPage.dart';
import 'favourite_toggle_icon_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic productDetails;
  const ProductDetailsScreen({super.key, required this.productDetails});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Map<String, dynamic> productDetailsData = {};
  List<Map<String, dynamic>> commentList = [];
  int quantityDetail = 1;
  double price = 0;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  int selectedRating = 0;

  @override
  void initState() {
    super.initState();
    getProductDetails();
    loadComments();
  }

  Future<void> getProductDetails() async {
    try {
      final details = await Productservice().getOrderDetailsById(widget.productDetails);
      setState(() {
        productDetailsData = details;
      });
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  Future<void> loadComments() async {
    try {
      // Gọi hàm lấy dữ liệu khách hàng từ API
      List<Map<String, dynamic>> comments =
      await Commentservice().getComments();

      setState(() {
        commentList = comments;
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error loading comments: $e');
    }
  }

  void incrementQuantity() {
    setState(() {
      if (quantityDetail < productDetailsData['quantity']) {
        quantityDetail++;
      }
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantityDetail > 1) {
        quantityDetail--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFf3e8a4),
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
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              child: productDetailsData != null
                  ? Column(
                children: [
                  const Text(
                    'Detail',
                    style: TextStyle(
                      color: Color(0xFF2f567a),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      width: 400,
                      height: 200,
                      child: Image(
                        image: AssetImage(
                            'assets/images/${productDetailsData['image']}'),
                        fit: BoxFit.cover,
                      )),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${productDetailsData['productname']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            children: [
                              Icon(Icons.star,
                                  color: Color(0xFF629bd0), size: 20),
                              SizedBox(width: 10),
                              Text(
                                '5.0',
                                style: TextStyle(
                                  color: Color(0xFF629bd0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 80),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            price = productDetailsData['sale'];
                            if (userProvider.isLoggedIn) {
                              Odersservice().createOrder(
                                quantityDetail,
                                price,
                                false,
                                productDetailsData['id'],
                                userProvider.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                  Text('add to cart successfully'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).canvasColor,
                            minimumSize: const Size(20,
                                30), // Adjust the width and height here
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_shopping_cart,
                                size:
                                24, // Adjust the icon size as needed
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.solidSquareMinus,
                                color: Color(0xFF325976)),
                            onPressed: decrementQuantity,
                          ),
                          Text(
                            '$quantityDetail',
                            style: const TextStyle(
                                color: Color(0xFF325976),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.solidSquarePlus,
                                color: Color(0xFF325976)),
                            onPressed: incrementQuantity,
                          ),
                          const SizedBox(width: 100),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '\$${productDetailsData['sale']}',
                        style: const TextStyle(
                          color: Color(0xFF325976),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const Divider(thickness: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              '${productDetailsData['description']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              softWrap: true,
                              maxLines: 30, // Đặt số dòng tối đa
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Row(
                    children: [
                      const Text(
                        'Quantity: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${productDetailsData['quantity']} In Stock',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                ],
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Comment',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: commentList
                        .where((comment) =>
                    comment['productid']['id'] ==
                        productDetailsData['id'])
                        .map((comment) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ...List.generate(comment['rating'].toInt(),
                                      (index) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    );
                                  }),
                              ...List.generate((5 - comment['rating']).toInt(),
                                      (index) {
                                    return const Icon(
                                      Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    );
                                  }),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            comment['userId']['username'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            comment['comment'],
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add A Comment',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your Star',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          // Cập nhật rating được chọn khi người dùng chọn một sao
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        child: Icon(
                          // Chọn màu vàng cho các sao đã chọn và các sao còn lại sẽ là màu xám
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Your Comment *',
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (userProvider.isLoggedIn) {
                          String comment = _commentController.text;
                          int rating = selectedRating;
                          int productId = productDetailsData['id'];
                          int userId = userProvider.id;
                          Commentservice().createcomment(
                              comment, rating, productId, userId);
                          // Load comments again after submitting
                          loadComments();
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
                        backgroundColor: const Color(0xFF629bd0),
                        fixedSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
