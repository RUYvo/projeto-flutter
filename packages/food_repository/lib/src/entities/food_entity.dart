import 'package:food_repository/src/entities/macros_entity.dart';
import 'package:food_repository/src/models/models.dart';

class FoodEntity {
  String foodId;
  String picture;
  String name;
  String description;
  bool followUp;
  bool promotion;
  double price;
  double discount;
  Macros macros;

  FoodEntity({
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

  Map<String, Object?> toDocument(){
    return {
      'foodId': foodId,
      'picture': picture,
      'name': name,
      'description': description,
      'followUp': followUp,
      'promotion': promotion,
      'price': price,
      'discount': discount,
      'macros': macros.toEntity().toDocument(),
    };
  }

  static FoodEntity fromDocument(Map<String, dynamic> doc){
    return FoodEntity(
      foodId: doc['foodId'],
      picture: doc['picture'],
      name: doc['name'],
      description: doc['description'],
      followUp: doc['followUp'],
      promotion: doc['promotion'],
      price: doc['price'],
      discount: doc['discount'],
      macros: Macros.fromEntity(MacrosEntity.fromDocument(doc['macros'])),
    );
  }
}