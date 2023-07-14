import 'dishes_class.dart';

class CartClass {
  final DishesClass dish;
  final String recipeCollectionId;
  int qty;

  CartClass({required this.dish, required this.recipeCollectionId, required this.qty});
}
