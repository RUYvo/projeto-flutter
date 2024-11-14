class CartEntity {
  final List<CartItemEntity> items;

  CartEntity({required this.items});

  Map<String, Object?> toDocument() {
    return {
      'items': items.map((item) => item.toDocument()).toList(),
    };
  }

  static CartEntity fromDocument(Map<String, dynamic> doc) {
    return CartEntity(
      items: (doc['items'] as List<dynamic>)
          .map((item) => CartItemEntity.fromDocument(item))
          .toList(),
    );
  }
}

class CartItemEntity {
  String foodId;
  int quantity;
  int priceInCents;

  CartItemEntity({
    required this.foodId,
    required this.quantity,
    required this.priceInCents,
  });

  get price => null;

  Map<String, Object?> toDocument() {
    return {
      'foodId': foodId,
      'quantity': quantity,
      'priceInCents': priceInCents,
    };
  }

  static CartItemEntity fromDocument(Map<String, dynamic> doc) {
    return CartItemEntity(
      foodId: doc['foodId'],
      quantity: doc['quantity'],
      priceInCents: doc['priceInCents'],
    );
  }
}
