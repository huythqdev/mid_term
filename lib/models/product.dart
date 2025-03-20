class Product {
  final String? id;
  final String idSanPham;
  final String loaiSP;
  final double gia;
  final String hinhAnh;

  Product({
    this.id,
    required this.idSanPham,
    required this.loaiSP,
    required this.gia,
    required this.hinhAnh,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id']?.toString(),
      idSanPham: map['idSanPham'],
      loaiSP: map['loaiSP'],
      gia: map['gia'].toDouble(),
      hinhAnh: map['hinhAnh'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idSanPham': idSanPham,
      'loaiSP': loaiSP,
      'gia': gia,
      'hinhAnh': hinhAnh,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, idSanPham: $idSanPham, loaiSP: $loaiSP, gia: $gia, hinhAnh: $hinhAnh)';
  }

}