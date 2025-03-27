import 'package:flutter/material.dart';
import 'package:midterm_project/screens/auth/product_detail_screen.dart';
import 'models/product.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/admin/admin_home.dart';
import 'screens/admin/add_product.dart';
import 'screens/admin/edit_product.dart';
import 'services/database_service.dart';
import 'screens/admin/delete_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Store Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/admin-home': (context) => AdminHome(),
        '/add-product': (context) => AddProduct(),
        '/edit-product': (context) => EditProduct(),
        '/delete-product': (context) => DeleteProduct(),
        // '/detail-product': (context) => ProductDetailScreen(),
        '/detail-product': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return ProductDetailScreen(product: product);
        },


      },
    );
  }
}