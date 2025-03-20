import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'), // Hình nền
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo ứng dụng
                  // Image.asset('assets/logo.jpg', height: 100),
                  SizedBox(height: 20),

                  // Form đăng nhập
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),

                            // Ô nhập tên đăng nhập
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Tên đăng nhập',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onSaved: (value) => username = value!,
                              validator: (value) =>
                              value!.isEmpty ? 'Vui lòng nhập tên đăng nhập' : null,
                            ),
                            SizedBox(height: 12),

                            // Ô nhập mật khẩu
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              obscureText: true,
                              onSaved: (value) => password = value!,
                              validator: (value) =>
                              value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
                            ),
                            SizedBox(height: 16),

                            // Nút đăng nhập
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                'Đăng nhập',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 10),

                            // Nút đăng ký
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text('Chưa có tài khoản? Đăng ký ngay'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm xử lý đăng nhập
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      bool success = await AuthService.login(username, password);
      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacementNamed(context, '/admin-home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thất bại')),
        );
      }
    }
  }
}
