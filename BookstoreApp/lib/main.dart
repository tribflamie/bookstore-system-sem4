import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:BookstoreApp/service/user_provider.dart';
import 'package:BookstoreApp/ui/NavigationBarPage.dart';

void main() async {
  // Đảm bảo đang khởi tạo định dạng ngày giờ cho ngôn ngữ Việt Nam
  await initializeDateFormatting('vi_VN', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Các provider khác nếu có
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookstore Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFfeffe7)),
        // Thiết lập màu sắc theo seedColor
        useMaterial3: true, // Sử dụng Material3
      ),
      home: const NavigationBarPage(),
    );
  }
}
