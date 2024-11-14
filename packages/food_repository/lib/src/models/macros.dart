import 'package:food_repository/src/entities/macros_entity.dart';

class Macros {
  double delivery;
  double time;
  double rating;

  Macros({
    required this.delivery,
    required this.time,
    required this.rating
  });

  MacrosEntity toEntity(){
    return MacrosEntity(
      delivery: delivery,
      time: time,
      rating: rating,
    );
  }

  static Macros fromEntity(MacrosEntity entity){
    return Macros(
      delivery: entity.delivery,
      time: entity.time,
      rating: entity.rating,
    );
  }
}