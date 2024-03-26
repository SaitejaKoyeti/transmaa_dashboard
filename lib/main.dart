import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transmaa_dashboard/sidebuttons/buyNsell.dart';
import 'package:transmaa_dashboard/sidebuttons/finance.dart';
import 'package:transmaa_dashboard/sidebuttons/insurance.dart';
import 'package:transmaa_dashboard/sidebuttons/loads.dart';
import 'package:transmaa_dashboard/sidebuttons/verification.dart';
import 'Email_login/login.dart';
import 'Screens/cancelled.dart';
import 'Screens/confirmed.dart';
import 'Screens/delivered.dart';
import 'Screens/driver_waiting.dart';
import 'Screens/ordersondway.dart';
import 'Screens/waiting.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/loads': (context) => LoadsScreen(),
        '/buy_sell': (context) => BuynSellScreen(),
        '/finance': (context) => FinanceScreen(),
        '/insurance': (context) => InsuranceScreen(),
        '/verification': (context) => VerificationScreen(),
        '/delivered_orders': (context) => Ordersdelivered(),
        '/cancelled_orders': (context) => CancelledOrdersScreen(),
        '/waiting_orders': (context) => WaitingordersScreen(),
        '/driver_waiting': (context) => DriversAcceptedOrders(),
        '/Orders_OntheWay': (context) => Ordersontheway(),
        '/confirmed_orders': (context) => ConfirmedordersScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Logistics Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmailLogin(),
    );
  }
}



