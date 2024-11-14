import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> items;

  const CartUpdated(this.items);

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  List<Object?> get props => [items];

  get foodList => null;
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
