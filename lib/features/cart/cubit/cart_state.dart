import '../models/cart_item.dart';

class CartState {
  final List<CartItem> items;

  const CartState(this.items);

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  int get totalItem {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
