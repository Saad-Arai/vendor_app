import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:food_vendor_app/screens/dashboard_screen.dart';
import 'package:food_vendor_app/screens/login_screen.dart';
import 'package:food_vendor_app/screens/register_screen.dart';
import 'package:food_vendor_app/services/drawer_services.dart';
import 'package:food_vendor_app/widgets/drawer_menu_widget.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DrawerServices _services = DrawerServices();
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  String title = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderDrawer(
          appBar: SliderAppBar(
              appBarColor: Colors.white,
              appBarHeight: 80,
              trailing: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.search),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.bell),
                  ),
                  IconButton(
                    onPressed: () => Share.share(
                        "Download the new Fodd Service App and share with your friends and Family members.\nPlayStore -  "),
                    icon: Icon(
                      Icons.share,
                      size: 20,
                    ),
                  ),
                ],
              ),
              title: Text(' ',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700))),
          key: _key,
          sliderOpenSize: 179,
          slider: SliderView(
            onItemClick: (title) {
              _key.currentState!.closeSlider();
              setState(() {
                this.title = title;
              });
            },
          ),
          child: _services.drawerScreen(title)),
    );
  }
}
