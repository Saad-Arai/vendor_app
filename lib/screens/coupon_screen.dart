import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_vendor_app/constraints/colors.dart';
import 'package:food_vendor_app/screens/add_edit_coupon_screen.dart';
import 'package:food_vendor_app/services/firebase_services.dart';
import 'package:intl/intl.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _services.coupons
              .where('sellerId', isEqualTo: _services.user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return Column(
              children: [
                Container(
                  color: AppColors.appbarcolor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.deepOrangeAccent),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            Navigator.pushNamed(context, AddEditCoupon.id);
                          },
                          child: Text('Add New Coupon',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('Title'),
                        ),
                        DataColumn(
                          label: Text('Rate'),
                        ),
                        DataColumn(
                          label: Text('Status'),
                        ),
                        DataColumn(
                          label: Text('Info'),
                        ),
                        DataColumn(
                          label: Text('Expiry'),
                        ),
                      ],
                      rows:
                          _couponList(snapshot.data as QuerySnapshot, context)),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  List<DataRow> _couponList(QuerySnapshot snapshot, context) {
    Iterable<DataRow?> newList = snapshot.docs.map(
      (DocumentSnapshot document) {
        if (document != null) {
          var date = document['Expiry'];
          var expiry = DateFormat.yMMMd().add_jm().format(date.toDate());
          return DataRow(cells: [
            DataCell(Text(document['title'])),
            DataCell(Text(document['discountRate'].toString())),
            DataCell(
              Text(document['active'] ? 'Active' : 'Inactive'),
            ),
            DataCell(Text(expiry.toString())),
            DataCell(
              IconButton(
                icon: Icon(Icons.info_outline_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddEditCoupon(document: document)),
                  );
                },
              ),
            )
          ]);
        }
      },
    ).toList();
    return newList as List<DataRow>;
  }
}
