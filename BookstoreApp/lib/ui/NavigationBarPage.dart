import 'package:BookstoreApp/service/user_provider.dart';
import 'package:BookstoreApp/ui/ProductHistory.dart';
import 'package:BookstoreApp/ui/cart/cart_screen.dart';
import 'package:BookstoreApp/ui/product_details/product_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'AboutUsPage.dart';
import 'ContactUsPage.dart';
import 'MyHomePage.dart';
import 'ProductPage.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});
  @override
  State<StatefulWidget> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyHomePage(),
    const AboutUsPage(),
    ProductPage(),
    ContactUsPage(),
    CartScreen(),
    ProductHistory(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<BottomNavigationBarItem> bottomNavBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.houseChimney),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.circleInfo),
        label: 'About Us',
      ),
      const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.productHunt),
        label: 'Product',
      ),
      const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.solidAddressCard),
        label: 'Contact Us',
      ),
      const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.cartShopping),
        label: 'Cart',
      ),
    ];

    // Add the 'History' item if the user is logged in
    bottomNavBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.highlighter),
        label: 'History',
      ),
    );
  
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black87,
          selectedItemColor: const Color(0xFFbdc53b),
          unselectedItemColor: Colors.white,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          iconSize: 20,
          onTap: _onItemTapped,
          items: bottomNavBarItems,
        ),
      ),
    );
  }
}
