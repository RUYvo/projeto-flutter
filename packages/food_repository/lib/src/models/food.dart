import 'package:food_repository/src/entities/food_entity.dart';
import 'macros.dart';

class Food {
  String foodId;
  String picture;
  String name;
  String description;
  bool followUp;
  bool promotion;
  double price;
  double discount;
  Macros macros;

  Food({
    required this.foodId,
    required this.picture,
    required this.name,
    required this.description,
    required this.followUp,
    required this.promotion,
    required this.price,
    required this.discount,
    required this.macros
  });

  get priceInCents => null;

  FoodEntity toEntity(){
    return FoodEntity(
      foodId: foodId,
      picture: picture,
      name: name,
      description: description,
      followUp: followUp,
      promotion: promotion,
      price: price,
      discount: discount,
      macros: macros,
    );
  }

  static Food fromEntity(FoodEntity entity){
    return Food(
      foodId: entity.foodId,
      picture: entity.picture,
      name: entity.name,
      description: entity.description,
      followUp: entity.followUp,
      promotion: entity.promotion,
      price: entity.price,
      discount: entity.discount,
      macros: entity.macros,
    );
  }
}