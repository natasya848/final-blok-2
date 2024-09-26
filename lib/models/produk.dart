class Produk {
  final int id;
  final int idkategori;
  final String judul;
  final String harga;
  final String hargax;
  final String thumbnail;

  // Constructor with required named parameters
  Produk({
    required this.id,
    required this.idkategori,
    required this.judul,
    required this.harga,
    required this.hargax,
    required this.thumbnail,
  });

  // Factory constructor to create an instance from JSON
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] as int,
      idkategori: json['idkategori'] as int,
      judul: json['judul'] as String,
      harga: json['harga'] as String,
      hargax: json['hargax'] as String,
      thumbnail: json['thumbnail'] as String,
    );
  }
}
