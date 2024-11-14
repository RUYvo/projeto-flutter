import 'package:user_repository/user_repository.dart';


class MyUser {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  Cart cart;

  MyUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    required this.cart,
  });

  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    hasActiveCart: false,
    cart: Cart(items: []),
  );

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      hasActiveCart: hasActiveCart,
      cart: cart.toEntity(),
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      hasActiveCart: entity.hasActiveCart,
      cart: Cart.fromEntity(entity.cart),
    );
  }
}
