import 'package:flutter/material.dart';
import 'package:food_vendor_app/constraints/colors.dart';
import 'package:food_vendor_app/screens/add_newproduct_screen.dart';
import 'package:food_vendor_app/widgets/published_product.dart';
import 'package:food_vendor_app/widgets/unpublished_product.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              color: AppColors.appbarcolor,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: Row(
                          children: [
                            Text('Products'),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              maxRadius: 8,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    '20',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, AddNewProduct.id);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Add New',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              ),
            ),
            TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: 'Published',
                  ),
                  Tab(
                    text: 'UN Published',
                  ),
                ]),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  PublishedProducts(),
                  UnPublishedProducts(),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
