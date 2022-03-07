import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_vendor_app/providers/product_provider.dart';
import 'package:food_vendor_app/services/firebase_services.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Category',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _services.category.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something Went Wring');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(document['image']),
                        ),
                        title: Text(document['name']),
                        onTap: () {
                          _provider.selectCategory(
                              document['name'], document['image']);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class SubCategoryList extends StatefulWidget {
  const SubCategoryList({Key? key}) : super(key: key);

  @override
  _SubCategoryListState createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Sub Category',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
              future: _services.category.doc(_provider.selectedCategory).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something Went Wring');
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Object? data = snapshot.data!.data() as Map;
                  return data != null
                      ? Expanded(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                  children: [
                                    Text('Main Category:'),
                                    FittedBox(
                                      child: Text(
                                        _provider.selectedCategory,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 3,
                            ),
                            Container(
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListView.builder(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          child: Text('${index + 1}'),
                                        ),
                                        title: Text(snapshot.data!['subCat']
                                            [index]['name']),
                                        onTap: () {
                                          _provider.selectSubCategory(snapshot
                                              .data!['subCat'][index]['name']);
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    itemCount: snapshot.data!['subCat'] == null
                                        ? 0
                                        : snapshot.data!['subCat'].length,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                      : Text('no category selected');
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }
}
