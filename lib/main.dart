import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopease/views/products_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: MediaQuery.of(context).size.width >= 900
            ? const Size(3486, 1052)
            : MediaQuery.of(context).size.width >= 600
                ? const Size(2148, 1636)
                : const Size(1080, 2220),
        minTextAdapt: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ShopEase',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const ProductListScreen(),
          );
        });
  }
}
