import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_vendor_app/services/firebase_services.dart';

class PublishedProducts extends StatelessWidget {
  const PublishedProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Container(
      child: StreamBuilder(
        stream:
            _services.products.where('published', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 80,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: <DataColumn>[
                DataColumn(
                  label: Expanded(child: Text('Product Name')),
                ),
                DataColumn(
                  label: Text('Image'),
                ),
                DataColumn(
                  label: Text('Actions'),
                ),
              ],
              rows: _productDetails(snapshot.data as QuerySnapshot),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _productDetails(snapshot) {
    List<DataRow> newList =
        snapshot.docs.map<DataRow>((DocumentSnapshot document) {
      if (document != null) {
        return DataRow(cells: [
          DataCell(Container(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 1),
                    child: Text(
                      'Name:  ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(document['productName'],
                        style: TextStyle(fontSize: 15)),
                  )),
                ],
              ),
              subtitle: Row(
                children: [
                  Text(
                    ' SKU: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    document['sku'],
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          )),
          DataCell(Card(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(document['productImage'])),
            ),
          )),
          DataCell(popUpButton(
            document.data(),
          )),
        ]);
      }
    }).toList();
    return newList;
  }

  Widget popUpButton(
    data,
  ) {
    FirebaseServices _services = FirebaseServices();

    return PopupMenuButton<String>(
        onSelected: (String value) {
          if (value == 'unpublish') {
            _services.unPublishProduct(
              id: data['productId'],
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'unpublish',
                child: ListTile(
                  leading: Icon(Icons.check),
                  title: Text('un Publish'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'preview',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Preview'),
                ),
              ),
            ]);
  }
}
