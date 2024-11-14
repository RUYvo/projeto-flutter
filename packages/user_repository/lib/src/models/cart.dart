import 'package:user_repository/user_repository.dart';


class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  int get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  CartEntity toEntity() {
    return CartEntity(
      items: items.map((item) => item.toEntity()).toList(),
    );
  }

  static Cart fromEntity(CartEntity entity) {
    return Cart(
      items: entity.items.map((item) => CartItem.fromEntity(item)).toList(),
    );
  }
}

class CartItem {
  String foodId;
  int quantity;
  int priceInCents;

  CartItem({
    required this.foodId,
    required this.quantity,
    required this.priceInCents,
  });

  CartItemEntity toEntity() {
    return CartItemEntity(
      foodId: foodId,
      quantity: quantity,
      priceInCents: priceInCents,
    );
  }

  static CartItem fromEntity(CartItemEntity entity) {
    return CartItem(
      foodId: entity.foodId,
      quantity: entity.quantity,
      priceInCents: entity.priceInCents,
    );
  }
  int get totalPrice => priceInCents * quantity;
}
