class Promo {
  final int id;
  final String image;
  final int toppingsIncluded;
  final String size;

  Promo({
    required this.id,
    required this.image,
    required this.toppingsIncluded,
    required this.size,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['id'] as int,
      image: json['image'] as String,
      toppingsIncluded: json['toppings_included'] as int,
      size: json['size'] as String,
    );
  }

  @override
  String toString() {
    return 'Promo{id: $id, image: $image, toppingsIncluded: $toppingsIncluded, size: $size}';
  }
}