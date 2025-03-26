class Product {
  String? id;
  String idSanPham;
  String tenSanPham; // Thêm trường mới
  String loaiSP;
  double gia;
  String hinhAnh;

  Product({
    this.id,
    required this.idSanPham,
    required this.tenSanPham, // Thêm vào constructor
    required this.loaiSP,
    required this.gia,
    required this.hinhAnh,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'idSanPham': idSanPham,
      'tenSanPham': tenSanPham, // Thêm vào map
      'loaiSP': loaiSP,
      'gia': gia,
      'hinhAnh': hinhAnh,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id']?.toString(),
      idSanPham: map['idSanPham'] ?? '',
      tenSanPham: map['tenSanPham'] ?? '', // Thêm vào constructor
      loaiSP: map['loaiSP'] ?? '',
      gia: (map['gia'] ?? 0).toDouble(),
      hinhAnh: map['hinhAnh'] ?? '',
    );
  }

}
