import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_vendor_app/services/firebase_services.dart';
import 'package:food_vendor_app/services/order_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryBoysList extends StatefulWidget {
  //const DeliveryBoysList({Key? key}) : super(key: key);

  final DocumentSnapshot document;
  DeliveryBoysList(this.document);

  @override
  State<DeliveryBoysList> createState() => _DeliveryBoysListState();
}

class _DeliveryBoysListState extends State<DeliveryBoysList> {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();
  GeoPoint? _shopLocation;
  @override
  void initState() {
    _services.getShopDetails().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            _shopLocation = value['location'];
          });
        }
      } else {
        print('No Data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text('Select Delivery Boy'),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _services.boys
                    .where('accVerified', isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      GeoPoint location = data['location'];
                      double distanceInMeters = _shopLocation == null
                          ? 0.0
                          : Geolocator.distanceBetween(
                                  _shopLocation!.latitude,
                                  _shopLocation!.longitude,
                                  location.latitude,
                                  location.longitude) /
                              1000;

                      if (distanceInMeters > 10) {
                        return Container(
                            //it will show only nearest delivery boy
                            );
                      }
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              EasyLoading.show(status: 'Assigning Boys');
                              _services
                                  .selectBoys(
                                      orderId: widget.document.id,
                                      location: document['location'],
                                      name: document['name'],
                                      email: document['email'],
                                      image: document['imageUrl'],
                                      phone: document['mobile'])
                                  .then((value) {
                                EasyLoading.showSuccess(
                                    'Assigned Delivery Boy');
                                Navigator.pop(context);
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                data['imageUrl'],
                              ),
                            ),
                            title: Text(data['name'] ?? 'default value'),
                            // subtitle: Text(
                            //     '${distanceInMeters.toStringAsFixed(1)}km'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    GeoPoint location = data['location'];
                                    _orderServices.launchMap(
                                        location, document['name']);
                                  },
                                  icon: Icon(
                                    Icons.map,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _orderServices.launchCall(
                                        'tel:${document['mobile']}');
                                  },
                                  icon: Icon(Icons.phone,
                                      color: Theme.of(context).primaryColor),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                          )
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
