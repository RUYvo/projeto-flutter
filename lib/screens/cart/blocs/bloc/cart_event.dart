import 'package:equatable/equatable.dart';
import 'package:food_repository/food_repository.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final Food food;
  final int quantity;

  const AddToCartEvent({required this.food, this.quantity = 1});

  @override
  List<Object?> get props => [food, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final Food food;

  const RemoveFromCartEvent(this.food);

  @override
  List<Object?> get props => [food];
}

class UpdateQuantityEvent extends CartEvent {
  final Food food;
  final int quantity;

  const UpdateQuantityEvent({required this.food, required this.quantity});

  @override
  List<Object?> get props => [food, quantity];
}

class ClearCartEvent extends CartEvent {}
