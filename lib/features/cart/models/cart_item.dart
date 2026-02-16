class CartItem {
  final int productId;
  final String title;
  final double price;
  final int quantity;
  final String thumbnail;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.thumbnail,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      title: title,
      price: price,
      quantity: quantity ?? this.quantity,
      thumbnail: thumbnail,
    );
  }
}
