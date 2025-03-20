import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  String _email = '';
  String _phoneNumber = '';

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu không khớp')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.register(
        username: _username,
        password: _password,
        email: _email,
        phoneNumber: _phoneNumber,
      );

      if (success) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Thành công'),
            content: Text('Đăng ký tài khoản thành công'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                  Navigator.of(context).pop(); // Quay lại màn hình đăng nhập
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tên đăng nhập đã tồn tại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Đăng ký tài khoản'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập tên đăng nhập' : null,
                onSaved: (value) => _username = value!,
              ),
              SizedBox(height: 16),

              // Email field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!value.contains('@')) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 16),

              // Phone number field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
                onSaved: (value) => _phoneNumber = value!,
              ),
              SizedBox(height: 16),

              // Password field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 16),

              // Confirm password field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu';
                  }
                  return null;
                },
                onSaved: (value) => _confirmPassword = value!,
              ),
              SizedBox(height: 24),

              // Register button
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 16),

              // Login link
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Đã có tài khoản? Đăng nhập ngay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}