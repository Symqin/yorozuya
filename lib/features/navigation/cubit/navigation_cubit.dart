import 'package:flutter_bloc/flutter_bloc.dart';

// State-nya cukup integer saja (0, 1, 2, 3)
class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0); // Default ke index 0 (Home)

  void setIndex(int newIndex) {
    emit(newIndex);
  }
}
