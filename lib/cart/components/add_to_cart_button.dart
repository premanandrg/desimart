import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../FIREBASE/firebase_config.dart';
import '../../app_config.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    Key? key,
    required this.productId,
    required this.contextX,
  }) : super(key: key);
  final String productId;
  final BuildContext contextX;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: myCartRef.doc(productId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> cartProduct) {
        if (cartProduct.connectionState == ConnectionState.waiting ||
            cartProduct.hasError) {
          return AddButton(
            productId: productId,
            contextX: contextX,
          );
        }

        return cartProduct.data.exists
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: defaultBackgroundColor,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                      offset: Offset(1, 2),
                      color: Colors.grey,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          decrementCartProduct(cartProduct.data['quantity']);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              right: 10, top: 7, bottom: 7, left: 5),
                          child: Icon(
                            Icons.remove,
                            size: 15,
                            color: appColor,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      cartProduct.data['quantity'].toString(),
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: appColor,
                          ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          incrementCartProduct(cartProduct.data['quantity']);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              right: 10, top: 7, bottom: 7, left: 5),
                          child: Icon(
                            Icons.add,
                            size: 15,
                            color: appColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : AddButton(
                productId: productId,
                contextX: contextX,
              );
      },
    );
  }

  void incrementCartProduct(int currentQuantity) {
    productsRef.doc(productId).get().then((product) {
      if (product['quantity'] > currentQuantity) {
        myCartRef.doc(productId).update({'quantity': currentQuantity + 1});
      } else {
        if (product['quantity'] < 1) {
          ScaffoldMessenger.of(contextX).showSnackBar(
            const SnackBar(
                duration: Duration(seconds: 2), content: Text('Out of Stock')),
          );
        } else {
          ScaffoldMessenger.of(contextX).showSnackBar(
            SnackBar(
                duration: const Duration(seconds: 2),
                content: Text('Only $currentQuantity products available')),
          );
        }
      }
    });
  }

  Future<void> decrementCartProduct(int currentQuantity) async {
    if (currentQuantity <= 1) {
      await myCartRef.doc(productId).delete();
    } else {
      myCartRef
          .doc(productId)
          .update({'quantity': FieldValue.increment(-1)}).then((value) {});
    }
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
    required this.productId,
    required this.contextX,
  }) : super(key: key);

  final String productId;
  final BuildContext contextX;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: defaultBackgroundColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(1, 2),
            color: Colors.grey,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            addProductToCart();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.add,
                  size: 15,
                  color: appColor,
                ),
                Text(
                  'Add',
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: appColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addProductToCart() {
    productsRef.doc(productId).get().then((value) {
      Map product = value.data() as Map;
      if (product['quantity'] > 0) {
        var data = {
          'timestamp': Timestamp.now(),
          'productId': productId,
          'quantity': 1,
          'vendorId': product['vendorId'],
        };
        myCartRef.doc(productId).set(data).then((value) {
          ScaffoldMessenger.of(contextX).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Product Added to cart')));
        });
      } else {
        ScaffoldMessenger.of(contextX).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2), content: Text('Out of Stock')));
      }
    });
  }
}
