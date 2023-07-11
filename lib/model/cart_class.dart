import 'dishes_class.dart';

class CartClass {
  final DishesClass dish;
  final String recipeCollectionId;
  final int qty;

  CartClass({required this.dish, required this.recipeCollectionId, required this.qty});
}
