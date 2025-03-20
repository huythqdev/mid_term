import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class DeleteProduct extends StatefulWidget {
  @override
  _DeleteProductState createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  final _formKey = GlobalKey<FormState>();
  String idSanPham = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xóa sản phẩm'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    bool success = await DatabaseService.deleteProduct(idSanPham);
                    if (success) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi khi xóa sản phẩm')),
                      );
                    }
                  }
                },
                child: Text('Xóa sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
