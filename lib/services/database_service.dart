import 'package:mongo_dart/mongo_dart.dart';
import '../models/product.dart';

class DatabaseService {
  static const String MONGO_URL = "mongodb://192.168.1.106:27017/Shoe_Store";
  static const String DATABASE_NAME = "Shoe_Store";
  static const String COLLECTION_NAME = "products";

  static Db? _db;
  static DbCollection? _collection;

  static Future<void> connect() async {
    try {
      _db = await Db.create("mongodb://192.168.1.106:27017/Shoe_Store");
      await _db!.open();
      _collection = _db!.collection(COLLECTION_NAME);
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  static Future<List<Product>> getProducts() async {
    try {
      final products = await _collection!.find().toList();
      return products.map((doc) => Product.fromMap(doc)).toList();
    } catch (e) {
      print("Error getting products: $e");
      return [];
    }
  }

  static Future<bool> addProduct(Product product) async {
    try {
      await _collection!.insert(product.toMap());
      return true;
    } catch (e) {
      print("Error adding product: $e");
      return false;
    }
  }

  // static Future<bool> updateProduct(dynamic id, Product updatedProduct) async {
  //   try {
  //     // Xử lý id một cách linh hoạt
  //     ObjectId objectId;
  //     if (id is ObjectId) {
  //       objectId = id;
  //     } else if (id is String) {
  //       // Nếu id đã là hex string
  //       if (id.length == 24) {
  //         objectId = ObjectId.fromHexString(id);
  //       } else {
  //         // Nếu id là string dạng ObjectId("...")
  //         final hexString = id.substring(9, 33); // Lấy phần hex string từ ObjectId("...")
  //         objectId = ObjectId.fromHexString(hexString);
  //       }
  //     } else {
  //       throw Exception("Invalid id format");
  //     }
  //
  //     final result = await _collection!.updateOne(
  //       where.eq('_id', objectId),
  //       modify
  //           .set('idSanPham', updatedProduct.idSanPham)
  //           .set('loaiSP', updatedProduct.loaiSP)
  //           .set('gia', updatedProduct.gia)
  //           .set('hinhAnh', updatedProduct.hinhAnh),
  //     );
  //
  //     return result.isSuccess;
  //   } catch (e) {
  //     print("Error updating product: $e");
  //     return false;
  //   }
  // }
  //
  static Future<bool> deleteProduct(String id) async {
    try {
      String hexId = id.substring(10, 34);
      final objectId = ObjectId.fromHexString(hexId);
      var result = await _collection!.deleteOne(where.id(objectId));
      return result.isSuccess;
    } catch (e) {
      print("Error deleting product: $e");
      return false;
    }
  }

  static Future<bool> updateProduct(Product updatedProduct) async{
    String hexId = updatedProduct.id!.substring(10, 34);
    final objectId = ObjectId.fromHexString(hexId);
    final result = await _collection!.updateOne(
      where.eq('_id',objectId),
      modify
          .set('idSanPham', updatedProduct.idSanPham)
          .set('loaiSP', updatedProduct.loaiSP)
          .set('gia', updatedProduct.gia)
          .set('hinhAnh', updatedProduct.hinhAnh),
    );
    // await collection.updateOne(where.eq('_id', ObjectId.parse(id)), modify.set('name', newData['name']));
    // print(updatedProduct);
    if (result.isSuccess) {
      print('Cập nhật thành công: ${result.nModified} document được cập nhật.');
      return true;
    } else {
      print('Cập nhật thất bại: ${result.errmsg}');
      return false;
    }
  }



  static Db getDb() {
    if (_db == null) {
      throw Exception("Database not connected. Call DatabaseService.connect() first.");
    }
    return _db!;
  }
}