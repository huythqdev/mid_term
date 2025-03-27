import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../services/database_service.dart';
import '../../models/product.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String idSanPham = '';
  String tenSanPham = '';
  String loaiSP = '';
  double gia = 0;
  String hinhAnh = '';

  // Chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        hinhAnh = image.path; // Lưu tạm đường dẫn nội bộ
      });

      // Upload ảnh lên server
      final url = await _uploadImage(image);
      if (url != null) {
        setState(() {
          hinhAnh = url; // Lưu URL ảnh từ server
        });
      }
    }
  }

  // Upload ảnh lên server và lấy URL ảnh
  Future<String?> _uploadImage(XFile imageFile) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://192.168.1.107:3000/upload"));
      // request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path)); // Đúng với Multer
      // request.files.add(await http.MultipartFile.fromPath('image', filePath)); // 'image' phải khớp với server

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return jsonDecode(responseData)['url']; // Trả về URL của ảnh
      }
    } catch (e) {
      print("Lỗi upload ảnh: $e");
    }
    return null;
  }

  Widget _buildImage() {
    if (hinhAnh.isEmpty) {
      return Text('Chưa có hình ảnh');
    }
    if (hinhAnh.startsWith('http')) {
      return Image.network(hinhAnh, height: 100, fit: BoxFit.cover);
    }
    return Image.file(File(hinhAnh), height: 100, fit: BoxFit.cover);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sản phẩm mới'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ID Sản phẩm'),
                onSaved: (value) => idSanPham = value!,
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập ID sản phẩm' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                onSaved: (value) => tenSanPham = value!,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên sản phẩm' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Loại sản phẩm'),
                onSaved: (value) => loaiSP = value!,
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập loại sản phẩm' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
                onSaved: (value) => gia = double.parse(value!),
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập giá' : null,
              ),
              SizedBox(height: 10),
              _buildImage(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Chọn hình ảnh'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final product = Product(
                      idSanPham: idSanPham,
                      tenSanPham:tenSanPham,
                      loaiSP: loaiSP,
                      gia: gia,
                      hinhAnh: hinhAnh,
                    );

                    if (await DatabaseService.addProduct(product)) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Thêm sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
