import 'package:flutter/material.dart';
import '../constants.dart';
import 'category_view.dart';
import 'dishes_view.dart';

class MenuView extends StatefulWidget {
  final Function updateCartQty;

  MenuView(this.updateCartQty);
  // const MenuView({super.key});
  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  int cartItemsLength = 0;

  @override
  void initState() {
    super.initState();
  }

  // Gets the starting date of the current week
  String findFirstDateOfTheWeek() {
    DateTime now = DateTime.now();
    DateTime firstDateCurrentWeek =
        now.subtract(Duration(days: now.weekday - 1));

    return "${firstDateCurrentWeek.day.toString().padLeft(2, '0')}/${firstDateCurrentWeek.month.toString().padLeft(2, '0')}/${firstDateCurrentWeek.year.toString()}";
  }

//Gets the last date of the current week
  String findLastDateOfTheWeek() {
    DateTime now = DateTime.now();
    DateTime lastDateCurrentWeek =
        now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    return "${lastDateCurrentWeek.day.toString().padLeft(2, '0')}/${lastDateCurrentWeek.month.toString().padLeft(2, '0')}/${lastDateCurrentWeek.year.toString()}";
  }

  void updateCartQuantity(int qty) {
    print('menu view cart qty');
    print(qty);
    setState(() {
      cartItemsLength = qty;
      submitTx();
    });
  }

  void submitTx() {
    widget.updateCartQty(cartItemsLength);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          // height: MediaQuery.of(context).size.height * 0.05,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Text('Menu',
                  style: TextStyle(
                      color: kPrimaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const Spacer(),
              Text('${findFirstDateOfTheWeek()} to ${findLastDateOfTheWeek()}',
                  style: const TextStyle(
                      color: kPrimaryTextColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 12)),
            ],
          ),
        ),
        Container(
          // height: MediaQuery.of(context).size.height * 0.1,
          padding: const EdgeInsets.all(10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CategoryView(),
            ],
          ),
        ),
        Container(
          // height: MediaQuery.of(context).size.height * 0.17,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: [DishesView(widget.updateCartQty)],
          ),
        ),
      ],
    );
  }
}
