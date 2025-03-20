import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/database_service.dart';
import '../../models/product.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  late Product _product;
  bool _isLoading = false;

  TextEditingController _idSanPhamController = TextEditingController();
  TextEditingController _loaiSPController = TextEditingController();
  TextEditingController _giaController = TextEditingController();
  String _hinhAnh = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Product) {
      _product = args;
      _idSanPhamController.text = _product.idSanPham;
      _loaiSPController.text = _product.loaiSP;
      _giaController.text = _product.gia.toString();
      _hinhAnh = _product.hinhAnh;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _hinhAnh = image.path;
      });
    }
  }
  // chay di em huy

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final updatedProduct = Product(
        id: _product.id, // Giữ nguyên id gốc
        idSanPham: _idSanPhamController.text,
        loaiSP: _loaiSPController.text,
        gia: double.tryParse(_giaController.text) ?? 0.0,
        hinhAnh: _hinhAnh,
      );

      print(updatedProduct);



      // Truyền trực tiếp id gốc
      // final success = await DatabaseService.updateProduct(
      //   _product.id,
      //   updatedProduct,
      // );
      final success = await DatabaseService.updateProduct(updatedProduct);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật sản phẩm thành công')),
        );
        Navigator.pop(context, true);
      } else {
        _showErrorDialog('Không thể cập nhật sản phẩm');
      }
    } catch (e) {
      _showErrorDialog('Lỗi cập nhật: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa sản phẩm')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Thêm dòng này để tránh lỗi tràn màn hình
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_hinhAnh.isNotEmpty)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _hinhAnh.startsWith('http')
                        ? Image.network(_hinhAnh, fit: BoxFit.cover)
                        : Image.file(File(_hinhAnh), fit: BoxFit.cover),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Chọn hình ảnh mới'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _idSanPhamController,
                  decoration: InputDecoration(
                    labelText: 'ID Sản phẩm',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập ID sản phẩm' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _loaiSPController,
                  decoration: InputDecoration(
                    labelText: 'Loại sản phẩm',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập loại sản phẩm' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _giaController,
                  decoration: InputDecoration(
                    labelText: 'Giá',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Vui lòng nhập giá';
                    if (double.tryParse(value) == null) return 'Giá không hợp lệ';
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _updateProduct,
                  child: Text('Cập nhật sản phẩm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idSanPhamController.dispose();
    _loaiSPController.dispose();
    _giaController.dispose();
    super.dispose();
  }
}