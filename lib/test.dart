// // lib/screens/product_form_screen.dart
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vls_shoes_app/services/mongodb_service.dart';
//
// class ProductFormScreen extends StatefulWidget {
//   final Map<String, dynamic>? product;  // Thêm ? để cho phép truyền null khi tạo mới
//
//   ProductFormScreen({this.product});  // Bỏ required để cho phép product là null khi tạo mới
//
//   @override
//   _ProductFormScreenState createState() => _ProductFormScreenState();
// }
//
// class _ProductFormScreenState extends State<ProductFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _idController = TextEditingController();  // Thêm controller cho ID sản phẩm
//   final _loaispController = TextEditingController();
//   final _giaController = TextEditingController();
//
//   String _imageData = '';  // Khởi tạo ban đầu là chuỗi rỗng
//   bool _isLoading = false;
//   bool _isEditing = false;
//   String _productId = '';
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.product != null) {
//       _isEditing = true;
//       _productId = widget.product!['idsanpham'];
//       _idController.text = _productId;
//       _loaispController.text = widget.product!['loaisp'] ?? '';
//       _giaController.text = (widget.product!['gia'] ?? 0).toString();
//       _imageData = widget.product!['hinhanh'] ?? '';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isEditing ? 'Sửa sản phẩm' : 'Thêm sản phẩm mới'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                   // Thêm trường ID sản phẩm khi tạo mới
//                   if (!_isEditing)
//               Padding(
//           padding: const EdgeInsets.only(bottom: 16.0),
//           child: TextFormField(
//             controller: _idController,
//             decoration: InputDecoration(
//               labelText: 'ID sản phẩm',
//               border: OutlineInputBorder(),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Vui lòng nhập ID sản phẩm';
//               }
//               return null;
//             },
//           ),
//         ),
//         TextFormField(
//           controller: _loaispController,
//           decoration: InputDecoration(
//             labelText: 'Loại sản phẩm',  // Sửa lại label phù hợp với field loaisp
//             border: OutlineInputBorder(),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Vui lòng nhập loại sản phẩm';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 16),
//         TextFormField(
//           controller: _giaController,
//           decoration: InputDecoration(
//             labelText: 'Giá',
//             border: OutlineInputBorder(),
//           ),
//           keyboardType: TextInputType.number,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Vui lòng nhập giá sản phẩm';
//             }
//             try {
//               double.parse(value);
//             } catch (e) {
//               return 'Giá phải là số';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 24),
//         Text(
//           'Hình ảnh sản phẩm:',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 😎,
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//             ),
//             child: _imageData.isNotEmpty
//                 ? _displayImage()
//                 : Center(
//               child: Text('Chưa có hình ảnh'),
//             ),
//           ),
//           SizedBox(height: 16),
//           ElevatedButton.icon(
//             icon: Icon(Icons.photo_camera),
//             label: Text('Chọn hình ảnh'),
//             onPressed: _pickImage,
//           ),
//           SizedBox(height: 32),
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : ElevatedButton(
//             onPressed: _saveProduct,
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Text(
//                 _isEditing ? 'Cập nhật' : 'Thêm sản phẩm',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           ],
//         ),
//       ),
//     ),
//     ),
//     );
//   }
//
//   // Widget để hiển thị hình ảnh tùy theo định dạng
//   Widget _displayImage() {
//     try {
//       if (_imageData.startsWith('data:image') || _imageData.contains('base64')) {
//         // Trường hợp dữ liệu là base64
//         String base64String = _imageData;
//         if (_imageData.contains(',')) {
//           base64String = _imageData.split(',').last;
//         }
//         return Image.memory(
//           base64Decode(base64String),
//           fit: BoxFit.contain,
//         );
//       } else if (_imageData.startsWith('http')) {
//         // Trường hợp là URL
//         return Image.network(
//           _imageData,
//           fit: BoxFit.contain,
//           loadingBuilder: (context, child, loadingProgress) {
//             if (loadingProgress == null) return child;
//             return Center(child: CircularProgressIndicator());
//           },
//           errorBuilder: (context, error, stackTrace) {
//             return Center(child: Text('Không thể tải hình ảnh'));
//           },
//         );
//       } else if (_imageData.startsWith('/')) {
//         // Trường hợp là local path
//         return Image.file(
//           File(_imageData),
//           fit: BoxFit.contain,
//           errorBuilder: (context, error, stackTrace) {
//             return Center(child: Text('Không thể tải hình ảnh'));
//           },
//         );
//       } else {
//         return Center(child: Text('Định dạng hình ảnh không hỗ trợ'));
//       }
//     } catch (e) {
//       return Center(child: Text('Lỗi hiển thị hình ảnh: $e'));
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 85,
//     );
//
//     if (pickedFile != null) {
//       try {
//         final bytes = await File(pickedFile.path).readAsBytes();
//         final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
//
//         setState(() {
//           _imageData = base64Image;
//         });
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi khi đọc ảnh: $e')),
//         );
//       }
//     }
//   }
//
//   Future<void> _saveProduct() async {
//     if (_formKey.currentState!.validate()) {
//       if (_imageData.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Vui lòng chọn hình ảnh cho sản phẩm')),
//         );
//         return;
//       }
//
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         final loaisp = _loaispController.text;
//         final gia = double.parse(_giaController.text);
//
//         bool success;
//         if (_isEditing) {
//           success = await MongoDBService.updateProduct(
//             _productId,
//             loaisp,
//             gia,
//             _imageData,
//           );
//         } else {
//           // Sử dụng ID từ controller khi tạo mới
//           final idsanpham = _idController.text;
//           final id = await MongoDBService.insertProduct(
//             idsanpham,  // Truyền ID vào
//             loaisp as double,
//             gia as String,
//             _imageData,
//           );
//           success = id != null;
//         }
//
//         if (success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(_isEditing ? 'Cập nhật thành công' : 'Thêm sản phẩm thành công')),
//           );
//           Navigator.of(context).pop(true);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Không thể lưu sản phẩm')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi: $e')),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
// }