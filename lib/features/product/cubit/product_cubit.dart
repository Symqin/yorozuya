import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'product_state.dart';
import '../models/product_model.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final Dio _dio = Dio();

  Future<void> fetchProducts() async {
    emit(ProductLoading());

    try {
      final response = await _dio.get('https://dummyjson.com/products');

      final List productsJson = response.data['products'];

      final products = productsJson
          .map((e) => ProductModel.fromJson(e))
          .toList();

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
