import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_vendor_app/services/firebase_services.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _Services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: _Services.vendorbanner.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Image.network(
                        document['imageUrl'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                      right: 10,
                      top: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                            onPressed: () {
                              EasyLoading.show(status: 'Deleting ...');
                              _Services.deleteBanner(id: document.id);
                              EasyLoading.dismiss();
                            },
                            icon: Icon(Icons.delete_outline)),
                      )),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
