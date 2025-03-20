// import 'package:flutter/material.dart';
// import 'dart:io';
// import '../../services/database_service.dart';
// import '../../models/product.dart';
//
// class AdminHome extends StatefulWidget {
//   @override
//   _AdminHomeState createState() => _AdminHomeState();
// }
//
// class _AdminHomeState extends State<AdminHome> {
//   List<Product> products = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadProducts();
//   }
//
//   Future<void> loadProducts() async {
//     final productList = await DatabaseService.getProducts();
//     setState(() {
//       products = productList;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quản lý sản phẩm'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () => Navigator.pushNamed(context, '/add-product'),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => loadProducts(),
//         child: ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             final product = products[index];
//             return Card(
//               child: ListTile(
//                 leading: _buildImage(product.hinhAnh),
//                 title: Text(product.idSanPham),
//                 subtitle: Text('${product.loaiSP} - ${product.gia}\$'),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         Navigator.pushNamed(
//                           context,
//                           '/edit-product',
//                           arguments: product,
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () async {
//                         await DatabaseService.deleteProduct(product.id!);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   /// Hàm kiểm tra loại ảnh và hiển thị đúng định dạng
//   Widget _buildImage(String hinhAnh) {
//     if (hinhAnh.isEmpty) {
//       return Icon(Icons.image_not_supported, size: 50);
//     }
//     if (hinhAnh.startsWith('http')) {
//       return Image.network(hinhAnh, height: 50, width: 50, fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
//       );
//     }
//     return Image.file(File(hinhAnh), height: 50, width: 50, fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
//     );
//   }
// }
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final productList = await DatabaseService.getProducts();
    setState(() {
      products = productList;
      isLoading = false;
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị khi tải dữ liệu
          : RefreshIndicator(
        onRefresh: loadProducts,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Hiển thị 2 sản phẩm trên 1 hàng
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(product);
            },
          ),
        ),
      ),
    );
  }

  /// Widget tạo giao diện Card sản phẩm
  Widget _buildProductCard(Product product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: _buildImage(product.hinhAnh),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.idSanPham,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('${product.loaiSP} - ${product.gia}\$', style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/edit-product',
                          arguments: product,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DatabaseService.deleteProduct(product.id!);
                        loadProducts();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Hàm kiểm tra loại ảnh và hiển thị đúng định dạng
  Widget _buildImage(String hinhAnh) {
    if (hinhAnh.isEmpty) {
      return Image.asset('assets/no_image.png', fit: BoxFit.cover);
    }
    if (hinhAnh.startsWith('http')) {
      return Image.network(
        hinhAnh,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
      );
    }
    return Image.file(
      File(hinhAnh),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
    );
  }
}
