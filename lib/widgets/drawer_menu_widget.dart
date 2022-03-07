import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_vendor_app/constraints/colors.dart';
import 'package:food_vendor_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class SliderView extends StatefulWidget {
  final Function(String)? onItemClick;

  const SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  User? user = FirebaseAuth.instance.currentUser;
  var vendorData;
  @override
  void initState() {
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot> getVendorData() async {
    var result = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(user!.uid)
        .get();
    setState(() {
      vendorData = result;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider
        .getShopName(vendorData != null ? vendorData.data()['shopName'] : '');
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 30,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FittedBox(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        //shop Picture
                        radius: 30,
                        backgroundImage: vendorData != null
                            ? NetworkImage(vendorData.data()['imageUrl'])
                            : null,
                      ),
                    ),
                    //cant add sized box here
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        vendorData != null
                            ? vendorData.data()['shopName']
                            : 'Shop Name',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'BalsamiqSans'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _SliderMenuItem(
                title: 'Dashboard',
                iconData: Icons.dashboard_outlined,
                onTap: widget.onItemClick),
            _SliderMenuItem(
                title: 'Product',
                iconData: Icons.shopping_bag_outlined,
                onTap: widget.onItemClick),
            _SliderMenuItem(
                title: 'Banner',
                iconData: CupertinoIcons.photo,
                onTap: widget.onItemClick),
            _SliderMenuItem(
                title: 'Coupons',
                iconData: CupertinoIcons.gift,
                onTap: widget.onItemClick),
            _SliderMenuItem(
                title: 'Order',
                iconData: Icons.list_alt_outlined,
                onTap: widget.onItemClick),
            _SliderMenuItem(
                title: 'About us',
                iconData: Icons.stacked_bar_chart,
                onTap: widget.onItemClick),
            _SliderMenuItem(
                title: 'LogOut',
                iconData: Icons.arrow_back_ios,
                onTap: widget.onItemClick),
          ],
        ),
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String)? onTap;

  const _SliderMenuItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title,
            style: TextStyle(
                color: Colors.black, fontFamily: 'BalsamiqSans_Regular')),
        leading: Icon(iconData, color: Colors.black),
        onTap: () => onTap?.call(title));
  }
}
