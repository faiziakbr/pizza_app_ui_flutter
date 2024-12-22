class SizeModel {
  final int id;
  final String name;
  final double price;
  final String image;

  SizeModel({required this.id, required this.name, required this.price, required this.image});

  // Factory constructor to parse from JSON
  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image
    };
  }
}