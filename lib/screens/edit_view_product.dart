import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_vendor_app/providers/product_provider.dart';
import 'package:food_vendor_app/services/firebase_services.dart';
import 'package:food_vendor_app/widgets/category_list.dart';
import 'package:provider/provider.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;

  EditViewProduct({required this.productId});

  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  final _formkey = GlobalKey<FormState>();

  String dropdownValue = 'Best Selling';
  List<String> _collection = [
    'Best Selling',
    'Featured Product',
    'Recently Added',
  ];

  var _brandText = TextEditingController();
  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _weightText = TextEditingController();
  var _priceText = TextEditingController();
  var _comparedPriceText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _taxTextController = TextEditingController();

  double discount = 10;
  String image = '';
  String categoryImage = '';
  var _image;
  bool _visible = false;
  bool _editing = true; //cant edit

  @override
  void initState() {
    // TODO: implement initState
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          _brandText.text = document['brand'];
          _skuText.text = document['sku'];
          _productNameText.text = document['productName'];
          _weightText.text = document['weight'];
          _priceText.text = document['price'].toString();
          _comparedPriceText.text = document['comparedPrice'].toString();
          discount = (double.parse(_priceText.text) /
              int.parse(_comparedPriceText.text) *
              100);
          image = document['productImage'];
          _descriptionText.text = document['description'];
          _categoryTextController = document['category']['mainCategory'];
          _subCategoryTextController = document['category']['subCategory'];
          dropdownValue = document['collection'];
          _stockTextController.text = document['stockQty'].toString();
          _lowStockTextController = document['lowStockQty'];
          _taxTextController.text = document['tax'].toString();
          categoryImage = document['categoryImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            child: Text("Edit", style: TextStyle(color: Colors.white)),
            onPressed: () {
              setState(() {
                _editing = false;
              });
            },
          )
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.black87,
                child: Center(
                    child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            )),
            Expanded(
                child: InkWell(
              onTap: () {
                if (_formkey.currentState!.validate()) {
                  EasyLoading.show(status: 'Saving ..');
                  if (_image != null) {
                    //first upload new image and save data
                    _provider
                        .uploadProductImage(_image.path, _productNameText.text)
                        .then((url) {
                      if (url != null) {
                        EasyLoading.dismiss();
                        _provider.updateProduct(
                          context: context,
                          productName: _productNameText.text,
                          weight: _weightText.text,
                          tax: double.parse(_taxTextController.text),
                          stockQty: int.parse(_stockTextController.text),
                          sku: _skuText.text,
                          price: double.parse(_priceText.text),
                          lowStockQty: int.parse(_lowStockTextController.text),
                          description: _descriptionText.text,
                          collection: dropdownValue,
                          brand: _brandText.text,
                          comparedPrice: int.parse(_comparedPriceText.text),
                          productId: widget.productId,
                          image: image,
                          category: _categoryTextController.text,
                          subCategory: _subCategoryTextController.text,
                          categoryImage: categoryImage,
                        );
                      }
                    });
                  } else {
                    //no need to change image, so just save new data , no need to upload image
                    _provider.updateProduct(
                      context: context,
                      productName: _productNameText.text,
                      weight: _weightText.text,
                      tax: double.parse(_taxTextController.text),
                      stockQty: int.parse(_stockTextController.text),
                      sku: _skuText.text,
                      price: double.parse(_priceText.text),
                      lowStockQty: int.parse(_lowStockTextController.text),
                      description: _descriptionText.text,
                      collection: dropdownValue,
                      brand: _brandText.text,
                      comparedPrice: int.parse(_comparedPriceText.text),
                      productId: widget.productId,
                      image: image,
                      category: _categoryTextController.text,
                      subCategory: _subCategoryTextController.text,
                      categoryImage: categoryImage,
                    );
                    EasyLoading.dismiss();
                  }
                  _provider.resetProvider();
                }
              },
              child: AbsorbPointer(
                absorbing: _editing,
                child: Container(
                  color: Colors.pinkAccent,
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            )),
          ],
        ),
      ),
      body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                AbsorbPointer(
                  absorbing: _editing,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80,
                            height: 30,
                            child: TextFormField(
                              controller: _brandText,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 10, right: 10),
                                hintText: 'Brand',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.1),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('SKU: '),
                              Container(
                                width: 50,
                                child: TextFormField(
                                  controller: _skuText,
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          controller: _productNameText,
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          controller: _weightText,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  prefixText: 'Rs:'),
                              controller: _priceText,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            width: 80,
                            child: TextFormField(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    prefixText: 'Rs:'),
                                controller: _comparedPriceText,
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.lineThrough)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.red,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                '${discount.toStringAsFixed(0)}% OFF',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Inclusive of all Taxes',
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                      InkWell(
                        onTap: () {
                          _provider.getProductImage().then((image) {
                            setState(() {
                              _image = image;
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: _image != null
                              ? Image.file(
                                  _image,
                                  height: 300,
                                )
                              : Image.network(
                                  image,
                                  height: 300,
                                ),
                        ),
                      ),
                      Text('About this product',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          maxLines: null,
                          controller: _descriptionText,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              'Category',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: AbsorbPointer(
                                absorbing:
                                    true, //this will block user entering category name manually
                                child: TextFormField(
                                    controller: _categoryTextController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Select Category name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Not Selected',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
                              ),
                            ),
                            Visibility(
                              visible: _editing ? false : true,
                              child: IconButton(
                                icon: Icon(Icons.edit_outlined),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CategoryList();
                                      }).whenComplete(() {
                                    setState(() {
                                      _categoryTextController.text =
                                          _provider.selectedCategory;
                                      _visible = true;
                                    });
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _visible,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: Row(
                            children: [
                              Text(
                                'Sub Category',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: true,
                                  child: TextFormField(
                                      controller: _subCategoryTextController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Select Sub Category name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'Not Selected',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.grey,
                                          )))),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit_outlined),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SubCategoryList();
                                      }).whenComplete(() {
                                    setState(() {
                                      _subCategoryTextController.text =
                                          _provider.selectedSubCategory;
                                    });
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'Collection',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            DropdownButton<String>(
                              hint: Text('Select Collection'),
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_drop_down),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: _collection.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text('Stock: '),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _stockTextController,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Low Stock: '),
                          SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _lowStockTextController,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Tax: '),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _taxTextController,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
