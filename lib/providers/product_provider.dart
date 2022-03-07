import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String selectedCategory = ' not selected';
  String selectedSubCategory = 'not selected';
  String categoryImage = '';
  late File image;
  String pickerError = '';
  String shopName = ''; //we need to bring shop name here
  String productUrl = '';
  selectCategory(mainCategory, categoryImage) {
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName) {
    this.shopName = shopName;
    //notifyListeners();
  }

  resetProvider() {
    //remove all the existing data before update next product
    this.selectedCategory = 'not selected';
    this.selectedSubCategory = '';
    this.categoryImage = '';
    this.image = File('');
    this.productUrl = '';
    notifyListeners();
  }

  //Upload Product Image
  Future<String> uploadProductImage(filePath, productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}/$productName$timeStamp')
        .getDownloadURL();
    this.productUrl = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<File> getProductImage() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'no image selected';
      print('no image selected');
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  //save product data to firestore
  Future<void>? saveProductDataToDb(
      //need to bring these details from Add Product Screen
      {
    productName,
    description,
    price,
    comparedPrice,
    collection,
    brand,
    sku,
    weight,
    tax,
    stockQty,
    lowStockQty,
    context,
  }) {
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      Future.delayed(Duration.zero, () async {
        _products.doc(timeStamp.toString()).set({
          'seller': {'shopName': this.shopName, 'sellerUid': user!.uid},
          'productName': productName,
          'description': description,
          'price': price,
          'comparedPrice': comparedPrice,
          'collection': collection,
          'brand': brand,
          'sku': sku,
          'category': {
            'mainCategory': this.selectedCategory,
            'subCategory': this.selectedSubCategory,
            'categoryImage': this.categoryImage
          },
          'weight': weight,
          'tax': tax,
          'stockQty': stockQty,
          'lowStockQty': lowStockQty,
          'published': false, //keep initial value false
          'productId': timeStamp.toString(),
          'productImage': this.productUrl,
        });
        this.alertDialog(
          context: context,
          title: 'SAVE DATA',
          content: 'Product Detail Saved Successfully',
        );
      });
    } catch (e) {
      this.alertDialog(
        context: context,
        title: 'save data',
        content: '${e.toString()}',
      );
    }
    return null;
  }

  Future<void>? updateProduct(
      //need to bring these details from Add Product Screen
      {
    productName,
    description,
    price,
    comparedPrice,
    collection,
    brand,
    sku,
    weight,
    tax,
    stockQty,
    lowStockQty,
    context,
    productId,
    image,
    category,
    subCategory,
    categoryImage,
  }) {
    var timeStamp = DateTime.now().microsecondsSinceEpoch;

    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      Future.delayed(Duration.zero, () async {
        _products.doc(productId).update({
          'productName': productName,
          'description': description,
          'price': price,
          'comparedPrice': comparedPrice,
          'collection': collection,
          'brand': brand,
          'sku': sku,
          'category': {
            'mainCategory': category,
            'subCategory': subCategory,
            'categoryImage':
                this.categoryImage == null ? categoryImage : this.categoryImage
          },
          'weight': weight,
          'tax': tax,
          'stockQty': stockQty,
          'lowStockQty': lowStockQty,
          'productImage': this.productUrl == null ? image : this.productUrl,
        });
        this.alertDialog(
          context: context,
          title: 'SAVE DATA',
          content: 'Product Detail Saved Successfully',
        );
      });
    } catch (e) {
      this.alertDialog(
        context: context,
        title: 'save data',
        content: '${e.toString()}',
      );
    }
    return null;
  }
}
