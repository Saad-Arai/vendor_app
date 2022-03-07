import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_vendor_app/providers/product_provider.dart';
import 'package:food_vendor_app/widgets/category_list.dart';
import 'package:provider/provider.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);
  static const String id = 'addnewproduct -screen';

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();

  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();

  var _comparedPriceTextController = TextEditingController();

  var _brandTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _stockTextController = TextEditingController();

  var _image;
  bool _visible = false;
  bool _track = false;
  String productName = '';
  String description = '';
  double price = 0;
  double comparedPrice = 0;
  String sku = '';
  String weight = '';
  double tax = 0;

  String dropdownValue = 'Best Selling';
  List<String> _collection = [
    'Best Selling',
    'Featured Product',
    'Recently Added',
  ];
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex:
          1, //will keep initial index 1 to avoid textfield clear automatic
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text('Products / Add'),
                        ),
                      ),
                      TextButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              //only if filled nessesary
                              if (_categoryTextController.text.isNotEmpty) {
                                if (_subCategoryTextController
                                    .text.isNotEmpty) {
                                  if (_image != null) {
                                    //image should be selected
                                    //upload image to storage
                                    EasyLoading.show(status: 'Saving..');
                                    _provider
                                        .uploadProductImage(
                                            _image.path, productName)
                                        .then((url) {
                                      if (url != null) {
                                        //upload product data to firestore
                                        EasyLoading.dismiss();
                                        _provider.saveProductDataToDb(
                                          context: context,
                                          comparedPrice: int.parse(
                                              _comparedPriceTextController
                                                  .text),
                                          brand: _brandTextController.text,
                                          collection: dropdownValue,
                                          description: description,
                                          lowStockQty: int.parse(
                                              _lowStockTextController.text),
                                          price: price,
                                          sku: sku,
                                          stockQty: int.parse(
                                              _stockTextController.text),
                                          tax: tax,
                                          weight: weight,
                                          productName: productName,
                                        );

                                        setState(() {
                                          //clear all the existing value after saved product
                                          _formKey.currentState!.reset();
                                          _comparedPriceTextController.clear();
                                          _subCategoryTextController.clear();
                                          _categoryTextController.clear();
                                          _brandTextController.clear();
                                          _track = false;
                                          _image = null;
                                          _visible = false;
                                        });
                                      } else {
                                        //upload failed
                                        _provider.alertDialog(
                                            context: context,
                                            title: 'IMAGE UPLOAD',
                                            content:
                                                'Failed to upload product image');
                                      }
                                    });
                                  } else {
                                    //image not selected
                                    _provider.alertDialog(
                                        context: context,
                                        title: 'PRODUCT IMAGE',
                                        content: 'Product Image Not Selected');
                                  }
                                } else {
                                  _provider.alertDialog(
                                      context: context,
                                      title: 'Sub Category',
                                      content: 'Sub Category Not Selected');
                                }
                              } else {
                                _provider.alertDialog(
                                    context: context,
                                    title: 'Main Category',
                                    content: 'Main Category Not Selected');
                              }
                            }
                          },
                          icon: Icon(
                            Icons.save,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Save',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ),
                ),
              ),
              TabBar(
                  unselectedLabelColor: Colors.black54,
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  tabs: [
                    Tab(
                      text: 'GENERAL',
                    ),
                    Tab(
                      text: 'INVENTORY',
                    ),
                  ]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Product Name';
                                      }
                                      setState(() {
                                        productName = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Product Name',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
                                TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    maxLength: 500,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter description';
                                      }
                                      setState(() {
                                        description = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'About Product',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _provider.getProductImage().then((image) {
                                        setState(() {
                                          _image = image;
                                        });
                                      });
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: Center(
                                          child: _image == null
                                              ? Text('Select Image')
                                              : Image.file(_image),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Selling Price';
                                      }
                                      setState(() {
                                        price = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Price',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
                                TextFormField(
                                    controller: _comparedPriceTextController,
                                    validator: (value) {
                                      //not compulsory
                                      if (price > double.parse(value!)) {
                                        //Always compared price should be higher
                                        return 'Compared price should be higher than price';
                                      }

                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText:
                                            'Compared Price', //price before discounr
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
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
                                        items: _collection
                                            .map<DropdownMenuItem<String>>(
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
                                TextFormField(
                                    controller: _brandTextController,
                                    //not compulsory
                                    decoration: InputDecoration(
                                        labelText: 'Brand',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
                                TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter SKU';
                                      }
                                      setState(() {
                                        sku = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'SKU', //Item code
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Category',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: AbsorbPointer(
                                          absorbing:
                                              true, //this will block user entering category name manually
                                          child: TextFormField(
                                              controller:
                                                  _categoryTextController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Select Category name';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: 'Not Selected',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
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
                                                return CategoryList();
                                              }).whenComplete(() {
                                            setState(() {
                                              _categoryTextController.text =
                                                  _provider.selectedCategory;
                                              _visible = true;
                                            });
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _visible,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sub Category',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            absorbing: true,
                                            child: TextFormField(
                                                controller:
                                                    _subCategoryTextController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Select Sub Category name';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    hintText: 'Not Selected',
                                                    labelStyle: TextStyle(
                                                        color: Colors.grey),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Colors.grey,
                                                    )))),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SubCategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                _subCategoryTextController
                                                        .text =
                                                    _provider
                                                        .selectedSubCategory;
                                              });
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Weight';
                                      }
                                      setState(() {
                                        weight = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText:
                                            'Weigth eg:kg, gm etc', //Item code
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
                                TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Tax %';
                                      }
                                      setState(() {
                                        tax = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Tax %', //Item code
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SwitchListTile(
                                title: Text('Track Inventory'),
                                activeColor: Theme.of(context).primaryColor,
                                subtitle: Text(
                                  'Switch on the track inventory',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                value: _track,
                                onChanged: (selected) {
                                  setState(() {
                                    _track = !_track;
                                  });
                                }),
                            Visibility(
                              visible: _track,
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                            controller: _stockTextController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Inventory Quantity*', //Item code
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Colors.grey,
                                                )))),
                                        TextFormField(
                                            //not Compulsary
                                            keyboardType: TextInputType.number,
                                            controller: _lowStockTextController,
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Inventory low stock quantity', //Item code
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Colors.grey,
                                                )))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
