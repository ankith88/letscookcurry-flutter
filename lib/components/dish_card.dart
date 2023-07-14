import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:letscookcurry/constants.dart';
import 'package:letscookcurry/model/dishes_class.dart';

// ignore: must_be_immutable
class DishCard extends StatefulWidget {
  late final DishesClass _dishes;
  final Function addItem;
  final int cartQty;

  DishCard(this._dishes, this.addItem, this.cartQty);

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
  int dishQty = 0;
  int simpleIntInput = 1;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  void submitTx() {
    dishQty++;
    widget.addItem(widget._dishes, dishQty); // Close the modal
  }

  void updateTx() {
    widget.addItem(widget._dishes, dishQty); // Close the modal
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // color: kSecondaryColor.withOpacity(0.6),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: kSecondaryColor, width: 0)),
        elevation: 10,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
              child: Image.asset(
                widget._dishes.image,
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget._dishes.name,
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.height * (18 / 812.0),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${widget._dishes.price}',
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.height * (18 / 812.0),
                        color: kPrimaryTextColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.cartQty == 0
                  ? ElevatedButton(
                      onPressed: () {
                        submitTx();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: kSecondaryButtonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        animationDuration: const Duration(seconds: 5),
                      ),
                      // icon: Icon(Icons.add, size: 18),
                      child: Text(
                        'Add to cart',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height *
                                (16 / 812.0)),
                      ))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InputQty(
                            maxVal: 5,
                            initVal: widget.cartQty,
                            steps: 1,
                            minVal: 1,
                            showMessageLimit: false,
                            borderShape: BorderShapeBtn.circle,
                            boxDecoration: const BoxDecoration(),
                            minusBtn: const Icon(Icons.remove, size: 16),
                            plusBtn: const Icon(
                              Icons.add,
                              size: 16,
                            ),
                            btnColor1: kSecondaryButtonColor,
                            btnColor2: kSecondaryButtonColor,
                            textFieldDecoration: const InputDecoration(
                                isDense: false,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20)),
                            onQtyChanged: (val) {
                              dishQty = val as int;
                            }),
                        ElevatedButton(
                            onPressed: () {
                              updateTx();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: kSecondaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              // elevation: 5,
                              animationDuration: const Duration(seconds: 5),
                            ),
                            // icon: Icon(Icons.add, size: 18),
                            child: Text(
                              'Update cart',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      (16 / 812.0)),
                            ))
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
