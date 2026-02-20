import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_state.dart';
import '../models/cart_item.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState([]));

  final _firestore = FirebaseFirestore.instance;

  /// Load cart saat app dibuka
  Future<void> loadCart(String userId) async {
    final doc = await _firestore.collection('carts').doc(userId).get();

    if (!doc.exists) {
      emit(const CartState([]));
      return;
    }

    final data = doc.data()!;
    final items = (data['items'] as List)
        .map(
          (e) => CartItem(
            productId: e['productId'],
            title: e['title'],
            price: (e['price'] as num).toDouble(),
            quantity: e['quantity'],
            thumbnail: e['thumbnail'],
          ),
        )
        .toList();

    emit(CartState(items));
  }

  /// Add / update item
  Future<void> addToCart({
    required String userId,
    required CartItem item,
  }) async {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((e) => e.productId == item.productId);

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(item);
    }

    await _firestore.collection('carts').doc(userId).set({
      'updatedAt': FieldValue.serverTimestamp(),
      'items': items
          .map(
            (e) => {
              'productId': e.productId,
              'title': e.title,
              'price': e.price,
              'quantity': e.quantity,
              'thumbnail': e.thumbnail,
            },
          )
          .toList(),
    });

    emit(CartState(items));
  }

  /// Update item quantity
  Future<void> updateQuantity(String userId, int productId, int newQty) async {
    if (newQty <= 0) {
      return removeFromCart(userId, productId);
    }

    final items = state.items.map((e) {
      if (e.productId == productId) {
        return e.copyWith(quantity: newQty);
      }
      return e;
    }).toList();

    await _syncCart(userId, items);
    emit(CartState(items));
  }

  /// Remove item
  Future<void> removeFromCart(String userId, int productId) async {
    final items = state.items.where((e) => e.productId != productId).toList();
    await _syncCart(userId, items);
    emit(CartState(items));
  }

  /// Clear cart (checkout sukses)
  Future<void> clearCart(String userId) async {
    await _firestore.collection('carts').doc(userId).delete();
    emit(const CartState([]));
  }

  /// Helper: sync cart items to Firestore
  Future<void> _syncCart(String userId, List<CartItem> items) async {
    if (items.isEmpty) {
      await _firestore.collection('carts').doc(userId).delete();
    } else {
      await _firestore.collection('carts').doc(userId).set({
        'updatedAt': FieldValue.serverTimestamp(),
        'items': items
            .map(
              (e) => {
                'productId': e.productId,
                'title': e.title,
                'price': e.price,
                'quantity': e.quantity,
                'thumbnail': e.thumbnail,
              },
            )
            .toList(),
      });
    }
  }
}
