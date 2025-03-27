import 'package:flutter/material.dart';
import 'dart:io';
import '../../services/database_service.dart';
import '../../models/product.dart';
import '../../services/auth_service.dart';
import '../auth/product_detail_screen.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String searchQuery = '';
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final productList = await DatabaseService.getProducts();
    setState(() {
      products = productList;
      filteredProducts = productList;
    });
  }

  void _searchProduct(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = products.where((product) {
        return product.tenSanPham.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _filterByCategory(String? category) {
    setState(() {
      selectedCategory = category;
      if (category == null || category.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts =
            products.where((product) => product.loaiSP == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'TECHZONE SHOP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => Navigator.pushNamed(context, '/add-product'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sản phẩm...',
                    prefixIcon: Icon(Icons.search, color: Colors.blue),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _searchProduct,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    hintText: 'Chọn danh mục',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['May Tinh Bang', 'Dien Thoai', 'May Tinh', 'Phu Kien', '']
                      .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.isEmpty ? 'Tất cả' : category),
                  ))
                      .toList(),
                  onChanged: _filterByCategory,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadProducts,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'product_${product.id}',
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: _buildImage(product.hinhAnh),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.tenSanPham,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    product.idSanPham,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${product.gia}\$',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Colors.blue, size: 20),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-product',
                                      arguments: product,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon:
                                  Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Xác nhận'),
                                        content: Text(
                                            'Bạn có chắc muốn xóa sản phẩm này?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Hủy'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await DatabaseService.deleteProduct(
                                                  product.id!);
                                              Navigator.pop(context);
                                              loadProducts();
                                            },
                                            child: Text('Xóa',
                                                style:
                                                TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          icon: Icon(Icons.logout),
          label: Text("Đăng xuất"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            await AuthService.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
    );
  }

  Widget _buildImage(String hinhAnh) {
    if (hinhAnh.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: Icon(Icons.image_not_supported,
            size: 40, color: Colors.grey[400]),
      );
    }

    if (hinhAnh.startsWith('http')) {
      return Image.network(
        hinhAnh,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, size: 40, color: Colors.grey[400]),
      );
    }

    return Image.file(
      File(hinhAnh),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.broken_image, size: 40, color: Colors.grey[400]),
    );
  }
}