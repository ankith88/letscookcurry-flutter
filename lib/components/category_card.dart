import 'package:flutter/material.dart';
import 'package:letscookcurry/constants.dart';
import 'package:letscookcurry/model/category_class.dart';

class CategoryCard extends StatelessWidget {
  // const CategoryCard({super.key});
  late final CategoryClass _category;

  CategoryCard(this._category);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: kPrimaryColor.withOpacity(0.8),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Center(
              child: Text(_category.name,
                  style: TextStyle(
                      color: kPrimaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
