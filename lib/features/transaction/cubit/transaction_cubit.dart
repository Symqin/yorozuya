import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../cart/cubit/cart_state.dart';

class TransactionCubit extends Cubit<bool> {
  TransactionCubit() : super(false);

  final _firestore = FirebaseFirestore.instance;

  Future<void> checkout({
    required String userId,
    required CartState cart,
  }) async {
    emit(true);

    await _firestore.collection('transactions').add({
      'userId': userId,
      'totalPrice': cart.totalPrice,
      'createdAt': FieldValue.serverTimestamp(),
      'items': cart.items
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

    emit(false);
  }
}
