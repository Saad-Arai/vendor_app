import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_vendor_app/providers/auth_provider.dart';
import 'package:food_vendor_app/providers/order_provider.dart';
import 'package:food_vendor_app/providers/product_provider.dart';
import 'package:food_vendor_app/screens/add_edit_coupon_screen.dart';
import 'package:food_vendor_app/screens/add_newproduct_screen.dart';

import 'package:food_vendor_app/screens/home_screen.dart';
import 'package:food_vendor_app/screens/login_screen.dart';
import 'package:food_vendor_app/screens/register_screen.dart';
import 'package:food_vendor_app/screens/reset_password_screen.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange, fontFamily: 'Lato'),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ResetPassword.id: (context) => const ResetPassword(),
        AddNewProduct.id: (context) => AddNewProduct(),
        AddEditCoupon.id: (context) => AddEditCoupon(),
      },
    );
  }
}
