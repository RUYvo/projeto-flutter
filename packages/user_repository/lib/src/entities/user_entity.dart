import 'cart_entity.dart';

class MyUserEntity {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  CartEntity cart;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    required this.cart,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'hasActiveCart': hasActiveCart,
      'cart': cart.toDocument(),
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'],
      email: doc['email'],
      name: doc['name'],
      hasActiveCart: doc['hasActiveCart'],
      cart: CartEntity.fromDocument(doc['cart']),
    );
  }
}
