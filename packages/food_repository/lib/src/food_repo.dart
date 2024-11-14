import 'models/models.dart';

abstract class FoodRepo {
  Future<List<Food>> getFood();  
}