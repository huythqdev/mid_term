import 'package:mongo_dart/mongo_dart.dart';
import 'database_service.dart';

class AuthService {
  static const String USERS_COLLECTION = "users";

  /// Đăng ký tài khoản mới
  static Future<bool> register({
    required String username,
    required String password,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      await DatabaseService.connect();
      final collection = DatabaseService.getDb().collection(USERS_COLLECTION);

      // Kiểm tra username đã tồn tại
      final existingUser = await collection.findOne(where.eq('username', username));
      if (existingUser != null) {
        print("⚠️ User đã tồn tại: $existingUser");
        return false; // Người dùng đã tồn tại
      }
      final newUser = {
        'username': username,
        'password': password, // Cần mã hóa mật khẩu trong thực tế
        'email': email,
        'phoneNumber': phoneNumber,
        'createdAt': DateTime.now().toUtc(),
      };

      print("📤 Đang insert: $newUser");

      final result = await collection.insertOne(newUser);

      print("✅ Insert result: ${result.isSuccess}");
      print("🔄 Inserted ID: ${result.id}");

      if (!result.isSuccess) {
        print("❌ Insert failed. Lỗi chi tiết: ${result.writeError?.errmsg}");
      }

      return result.isSuccess;
    } catch (e) {
      print("❌ Error registering user: $e");
      return false;
    }
  }
  /// Đăng nhập
  static Future<bool> login(String username, String password) async {
    try {
      final collection = DatabaseService.getDb().collection(USERS_COLLECTION);
      final user = await collection.findOne(
        where.eq('username', username).eq('password', password),
      );

      return user != null;
    } catch (e) {
      print(" Error logging in: $e");
      return false;
    }
  }
}
