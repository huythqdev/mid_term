import 'package:flutter/material.dart';
import 'dart:io';
import '../../services/database_service.dart';
import '../../models/product.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final productList = await DatabaseService.getProducts();
    setState(() {
      products = productList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/add-product'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => loadProducts(),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              child: ListTile(
                leading: _buildImage(product.hinhAnh),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.tenSanPham, // Hiển thị tên sản phẩm
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.idSanPham,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                subtitle: Text('${product.loaiSP} - ${product.gia}\$'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/edit-product',
                          arguments: product,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DatabaseService.deleteProduct(product.id!);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Hàm kiểm tra loại ảnh và hiển thị đúng định dạng
  Widget _buildImage(String hinhAnh) {
    if (hinhAnh.isEmpty) {
      return Icon(Icons.image_not_supported, size: 50);
    }
    if (hinhAnh.startsWith('http')) {
      return Image.network(hinhAnh, height: 50, width: 50, fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
      );
    }
    return Image.file(File(hinhAnh), height: 50, width: 50, fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
    );
  }
}
